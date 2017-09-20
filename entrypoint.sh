#!/bin/sh

set -e

if [ ! -z "$TZ" ]
then
  cp /usr/share/zoneinfo/$TZ /etc/localtime
  echo $TZ > /etc/timezone
fi

rm -f /tmp/sync.pid

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
    if [ -z "$FORCE_SYNC" ]
    then
      echo "INFO: Add FORCE_SYNC=1 to perform a sync upon boot"
    else
      /sync.sh
    fi

    # Setup cron schedule
    crontab -d
    echo "$CRON /sync.sh >>/tmp/sync.log 2>&1" > /tmp/crontab.tmp
    if [ -z "$CRON_ABORT" ]
    then
      echo "INFO: Add CRON_ABORT=\"0 6 * * *\" to cancel outstanding sync at 6am"
    else
      echo "$CRON_ABORT /sync-abort.sh >>/tmp/sync.log 2>&1" >> /tmp/crontab.tmp
    fi
    crontab /tmp/crontab.tmp
    rm /tmp/crontab.tmp

    # Start cron
    echo "INFO: Starting crond ..."
    touch /tmp/sync.log
    touch /tmp/crond.log
    crond -b -l 0 -L /tmp/crond.log
    echo "INFO: crond started"
    tail -F /tmp/crond.log /tmp/sync.log
  fi
fi

