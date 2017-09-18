#!/bin/sh

set -e

if [ -z "$SYNC_SRC" ] || [ -z "$SYNC_DEST" ]
then
  echo "INFO: No SYNC_SRC and SYNC_DEST found. Starting rclone config"
  rclone config $RCLONE_OPTS
  echo "INFO: Define SYNC_SRC and SYNC_DEST to start sync process."
else
  /sync.sh
fi

