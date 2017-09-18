#!/bin/sh

set -e

if test "$(rclone ls $SYNC_SRC $RCLONE_OPTS)"; then
  # the source directory is not empty
  # it can be synced without clear data loss
  echo "INFO: Starting rclone sync $SYNC_SRC $SYNC_DEST $RCLONE_OPTS $SYNC_OPTS"
  rclone sync $SYNC_SRC $SYNC_DEST $RCLONE_OPTS $SYNC_OPTS
else
  echo "WARNING: Source directory is empty. Skipping sync command."
fi
