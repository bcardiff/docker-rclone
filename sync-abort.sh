#!/bin/sh

set -e

if [ ! -f /tmp/sync.pid ]
then
  echo "INFO: No outstanding sync $(date)"
else
  echo "INFO: Stopping sync pid $(cat /tmp/sync.pid) $(date)"

  kill -15 $(cat /tmp/sync.pid)
  rm -f /tmp/sync.pid
fi
