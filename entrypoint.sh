#!/bin/sh

set -e

if [ -z "$SYNC_SRC" ] || [ -z "$SYNC_DEST" ]
then
  echo "INFO: No SYNC_SRC and SYNC_DEST found. Starting rclone config"
  rclone config $RCLONE_OPTS
  echo "INFO: Define SYNC_SRC and SYNC_DEST to start sync process."
else
  # SYNC_SRC and SYNC_DEST setup
  # run sync either once or in cron depending on CRON
  if [ -z "$CRON" ]
  then
    echo "INFO: No CRON setting found. Running sync once."
    echo "INFO: Add CRON=\"0 0 * * *\" to perform sync every midnight"
    /sync.sh
  else
    # Setup cron schedule
    crontab -d
    echo "$CRON /sync.sh >>/tmp/sync.log 2>&1" > /config/crontab.tmp
    crontab /config/crontab.tmp
    rm /config/crontab.tmp

    # Start cron
    echo "INFO: Starting crond ..."
    touch /tmp/sync.log
    touch /tmp/crond.log
    crond -b -l 0 -L /tmp/crond.log
    echo "INFO: crond started"
    tail -F /tmp/crond.log /tmp/sync.log
  fi
fi

