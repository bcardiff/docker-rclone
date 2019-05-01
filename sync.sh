#!/bin/sh

set -e

echo "INFO: Starting sync.sh pid $$ $(date)"

# Delete logs by user request
if [ ! -z "${ROTATE_LOG##*[!0-9]*}" ]
then
  echo "INFO: Removing logs older than $ROTATE_LOG day(s)..."
  find /logs/*.txt -mtime +$ROTATE_LOG -type f -delete
fi

if [ `lsof | grep $0 | wc -l | tr -d ' '` -gt 1 ]
then
  echo "WARNING: A previous $RCLONE_CMD is still running. Skipping new $RCLONE_CMD command."
else

  echo $$ > /tmp/sync.pid

  if [ ! -z "$RCLONE_DIR_CHECK_SKIP" ]
  then
    echo "INFO: Skipping source directory check..."
    if [ ! -z "$OUTPUT_LOG" ]
    then
      d=$(date +%Y_%m_%d-%H_%M_%S)
      LOG_FILE="/logs/$d.txt"
      echo "INFO: Log file output to $LOG_FILE"
      echo "INFO: Starting rclone $RCLONE_CMD $SYNC_SRC $SYNC_DEST $RCLONE_OPTS $SYNC_OPTS --log-file=${LOG_FILE}"
      rclone $RCLONE_CMD $SYNC_SRC $SYNC_DEST $RCLONE_OPTS $SYNC_OPTS --log-file=${LOG_FILE}
      export RETURN_CODE=$?
    else
      echo "INFO: Starting rclone $RCLONE_CMD $SYNC_SRC $SYNC_DEST $RCLONE_OPTS $SYNC_OPTS"
      rclone $RCLONE_CMD $SYNC_SRC $SYNC_DEST $RCLONE_OPTS $SYNC_OPTS
      export RETURN_CODE=$?
    fi
  else
    if test "$(rclone $RCLONE_DIR_CMD $SYNC_SRC $RCLONE_OPTS)"; then
    echo "INFO: Source directory is not empty and can be processed without clear loss of data"
    if [ ! -z "$OUTPUT_LOG" ]
    then
      d=$(date +%Y_%m_%d-%H_%M_%S)
      LOG_FILE="/logs/$d.txt"
      echo "INFO: Log file output to $LOG_FILE"
      echo "INFO: Starting rclone $RCLONE_CMD $SYNC_SRC $SYNC_DEST $RCLONE_OPTS $SYNC_OPTS --log-file=${LOG_FILE}"
      rclone $RCLONE_CMD $SYNC_SRC $SYNC_DEST $RCLONE_OPTS $SYNC_OPTS --log-file=${LOG_FILE}
      export RETURN_CODE=$?
    else
      echo "INFO: Starting rclone $RCLONE_CMD $SYNC_SRC $SYNC_DEST $RCLONE_OPTS $SYNC_OPTS"
      rclone $RCLONE_CMD $SYNC_SRC $SYNC_DEST $RCLONE_OPTS $SYNC_OPTS
      export RETURN_CODE=$?
    fi
      if [ -z "$CHECK_URL" ]
      then
        echo "INFO: Define CHECK_URL with https://healthchecks.io to monitor $RCLONE_CMD job"
      else
        if [ "$RETURN_CODE" == 0 ]
        then
          wget $CHECK_URL -O /dev/null
        else
          wget $FAIL_URL -O /dev/null
        fi
      fi
    else
      echo "WARNING: Source directory is empty. Skipping $RCLONE_CMD command."
    fi
  fi

rm -f /tmp/sync.pid

fi
