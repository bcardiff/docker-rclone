#!/bin/sh

set -e

echo "INFO: Starting sync.sh pid $$ $(date)"

if [ `lsof | grep $0 | wc -l | tr -d ' '` -gt 1 ]
then
  echo "WARNING: A previous sync is still running. Skipping new sync command."
else

echo $$ > /tmp/sync.pid

if test "$(rclone ls --max-depth 1 $SYNC_SRC $RCLONE_OPTS)"; then
  # Send a start ping if a) START_URL is explicitly set OR b) if Healthchecks.io is used as CHECK_URL provider
  if [ -z ${START_URL+x} ]
  then
    if echo "$CHECK_URL" | grep "hc-ping"
    then
      wget "${CHECK_URL}/start" -O /dev/null
    fi
  else
    wget $START_URL -O /dev/null
  fi
    
  # the source directory is not empty
  # it can be synced without clear data loss
  echo "INFO: Starting rclone sync $SYNC_SRC $SYNC_DEST $RCLONE_OPTS $SYNC_OPTS"
  rclone sync $SYNC_SRC $SYNC_DEST $RCLONE_OPTS $SYNC_OPTS

  # Send "done" ping to HC, if set
  if [ -z "$CHECK_URL" ]
  then
    echo "INFO: Define CHECK_URL with https://healthchecks.io to monitor sync job"
  else
    wget $CHECK_URL -O /dev/null
  fi
else
  echo "WARNING: Source directory is empty. Skipping sync command."
fi

rm -f /tmp/sync.pid

fi
