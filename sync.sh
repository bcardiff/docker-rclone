#!/bin/sh

# Function to check if return code is in the success codes list
is_success_code() {
  local code=$1
  for success_code in $SUCCESS_CODES; do
    if [ "$success_code" = "$code" ]; then
      return 0  # Match found, return success
    fi
  done
  return 1  # No match found, return failure
}

echo "INFO: Starting sync.sh pid $$ $(date)"

if [ `lsof | grep $0 | wc -l | tr -d ' '` -gt 1 ]
then
  echo "WARNING: A previous $RCLONE_CMD is still running. Skipping new $RCLONE_CMD command."
else

  # Signal start oh sync.sh to healthchecks.io
  if [ ! -z "$CHECK_URL" ]
  then
    echo "INFO: Sending start signal to healthchecks.io"
    wget $CHECK_URL/start -O /dev/null
  fi

  # Delete logs by user request
  if [ ! -z "${ROTATE_LOG##*[!0-9]*}" ]
  then
    echo "INFO: Removing logs older than $ROTATE_LOG day(s)..."
    touch /logs/tmp.txt && find /logs/*.txt -mtime +$ROTATE_LOG -type f -delete && rm -f /logs/tmp.txt
  fi

  echo $$ > /tmp/sync.pid

  # Evaluate any sync options
  if [ ! -z "$SYNC_OPTS_EVAL" ]
  then
    SYNC_OPTS_EVALUALTED=$(eval echo $SYNC_OPTS_EVAL)
    echo "INFO: Evaluated SYNC_OPTS_EVAL to: ${SYNC_OPTS_EVALUALTED}"
    SYNC_OPTS_ALL="${SYNC_OPTS} ${SYNC_OPTS_EVALUALTED}"
  else
    SYNC_OPTS_ALL="${SYNC_OPTS}"
  fi

  if [ ! -z "$RCLONE_DIR_CHECK_SKIP" ]
  then
    echo "INFO: Skipping source directory check..."
    if [ ! -z "$OUTPUT_LOG" ]
    then
      d=$(date +%Y_%m_%d-%H_%M_%S)
      LOG_FILE="/logs/$d.txt"
      echo "INFO: Log file output to $LOG_FILE"
      echo "INFO: Starting rclone $RCLONE_CMD $SYNC_SRC $SYNC_DEST $RCLONE_OPTS $SYNC_OPTS_ALL --log-file=${LOG_FILE}"
      set +e
      eval "rclone $RCLONE_CMD $SYNC_SRC $SYNC_DEST $RCLONE_OPTS $SYNC_OPTS_ALL --log-file=${LOG_FILE}"
      export RETURN_CODE=$?
      set -e
    else
      echo "INFO: Starting rclone $RCLONE_CMD $SYNC_SRC $SYNC_DEST $RCLONE_OPTS $SYNC_OPTS_ALL"
      set +e
      eval "rclone $RCLONE_CMD $SYNC_SRC $SYNC_DEST $RCLONE_OPTS $SYNC_OPTS_ALL"
      export RETURN_CODE=$?
      set -e
    fi
    echo "INFO: $RCLONE_CMD finished with return code: $RETURN_CODE"
  else
    set e+
    if test "$(rclone --max-depth $RCLONE_DIR_CMD_DEPTH $RCLONE_DIR_CMD "$(eval echo $SYNC_SRC)" $RCLONE_OPTS)"; then
    set e-
    echo "INFO: Source directory is not empty and can be processed without clear loss of data"
    if [ ! -z "$OUTPUT_LOG" ]
    then
      d=$(date +%Y_%m_%d-%H_%M_%S)
      LOG_FILE="/logs/$d.txt"
      echo "INFO: Log file output to $LOG_FILE"
      echo "INFO: Starting rclone $RCLONE_CMD $SYNC_SRC $SYNC_DEST $RCLONE_OPTS $SYNC_OPTS_ALL --log-file=${LOG_FILE}"
      set +e
      eval "rclone $RCLONE_CMD $SYNC_SRC $SYNC_DEST $RCLONE_OPTS $SYNC_OPTS_ALL --log-file=${LOG_FILE}"
      export RETURN_CODE=$?
      set -e
      echo "INFO: $RCLONE_CMD finished with return code: $RETURN_CODE"
    else
      echo "INFO: Starting rclone $RCLONE_CMD $SYNC_SRC $SYNC_DEST $RCLONE_OPTS $SYNC_OPTS_ALL"
      set +e
      eval "rclone $RCLONE_CMD $SYNC_SRC $SYNC_DEST $RCLONE_OPTS $SYNC_OPTS_ALL"
      export RETURN_CODE=$?
      set -e
      echo "INFO: $RCLONE_CMD finished with return code: $RETURN_CODE"
    fi
    else
      echo "WARNING: Source directory is empty. Skipping $RCLONE_CMD command."
    fi
  fi

  # Wrap up healthchecks.io call with complete or failure signal
  if [ -z "$CHECK_URL" ]
  then
    echo "INFO: Define CHECK_URL with https://healthchecks.io to monitor $RCLONE_CMD job"
  else
    if is_success_code "$RETURN_CODE"; then
      if [ ! -z "$OUTPUT_LOG" ] && [ ! -z "$HC_LOG" ] && [ -f "$LOG_FILE" ]
      then
        echo "INFO: Sending complete signal with logs to healthchecks.io"
        m=$(tail -c 10000 "$LOG_FILE")
	wget $CHECK_URL -O /dev/null --post-data="$m"
      else
	echo "INFO: Sending complete signal to healthchecks.io"
        wget $CHECK_URL -O /dev/null --post-data="SUCCESS"
      fi
    else
      if [ ! -z "$OUTPUT_LOG" ] && [ ! -z "$HC_LOG" ] && [ -f "$LOG_FILE" ]
      then
        echo "INFO: Sending failure signal with logs to healthchecks.io"
        m=$(tail -c 10000 "$LOG_FILE")
        wget $FAIL_URL -O /dev/null --post-data="$m"
      else
	echo "INFO: Sending failure signal to healthchecks.io"
        wget $FAIL_URL -O /dev/null --post-data="Check container logs"
      fi
    fi
  fi

rm -f /tmp/sync.pid

fi
