#!/bin/sh

set -e

echo "INFO: Starting rclone sync $SYNC_SRC $SYNC_DEST $RCLONE_OPTS $SYNC_OPTS"
rclone sync $SYNC_SRC $SYNC_DEST $RCLONE_OPTS $SYNC_OPTS
