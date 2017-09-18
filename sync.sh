#!/bin/sh

set -e

echo "INFO: Starting sync.sh $(date)"

if [ `lsof | grep $0 | wc -l | tr -d ' '` -gt 1 ]
then
  echo "WARNING: A previous sync is still running. Skipping new sync command."
else
if test "$(rclone ls $SYNC_SRC $RCLONE_OPTS)"; then
  # the source directory is not empty
  # it can be synced without clear data loss
  echo "INFO: Starting rclone sync $SYNC_SRC $SYNC_DEST $RCLONE_OPTS $SYNC_OPTS"
  rclone sync $SYNC_SRC $SYNC_DEST $RCLONE_OPTS $SYNC_OPTS

  if [ -z "$CHECK_URL" ]
  then
    echo "INFO: Define CHECK_URL with https://healthchecks.io to monitor sync job"
  else
    wget $CHECK_URL -O /dev/null
  fi
else
  echo "WARNING: Source directory is empty. Skipping sync command."
fi

fi
