#!/bin/sh

echo "INFO: Starting sync.sh pid $$ $(date)"

if [ `lsof | grep $0 | wc -l | tr -d ' '` -gt 1 ]
then
  echo "WARNING: A previous sync is still running. Skipping new sync command."
else

echo $$ > /tmp/sync.pid

if test "$(rclone ls $SYNC_SRC $RCLONE_OPTS)"; then
  # the source directory is not empty
  # it can be synced without clear data loss
  echo "INFO: Starting rclone $COMMAND $SYNC_SRC $SYNC_DEST $RCLONE_OPTS $SYNC_OPTS"
  rclone $COMMAND $SYNC_SRC $SYNC_DEST $RCLONE_OPTS $SYNC_OPTS
  export RETURN_CODE=$?
  if [ -z "$CHECK_URL" ]
  then
    echo "INFO: Define CHECK_URL with https://healthchecks.io to monitor sync job"
  else
    if [ "$RETURN_CODE" == 0 ]
    then
      wget $CHECK_URL -O /dev/null
    else
      wget $FAIL_URL -O /dev/null
    fi
  fi
else
  echo "WARNING: Source directory is empty. Skipping sync command."
fi

rm -f /tmp/sync.pid

fi
