#!/bin/bash

DOCKER_BUILD_OPTS=--no-cache

oneTimeSetUp() {
  docker build $DOCKER_BUILD_OPTS -t rclone-test .. > /dev/null
}

oneTimeTearDown() {
  docker rmi $(docker image ls -q rclone-test*) > /dev/null
}

setUp() {
  rm -rf dest
  mkdir dest
}

testCanBuildSpecificVersion() {
  docker build $DOCKER_BUILD_OPTS --build-arg RCLONE_VERSION=v1.45 -t rclone-test-1.45 .. > /dev/null
  assertEquals $? 0
}

testCanBuildCurrentVersion() {
  docker build $DOCKER_BUILD_OPTS --build-arg RCLONE_VERSION=current -t rclone-test-current .. > /dev/null
  assertEquals $? 0
}

testSourceIsSyncToDest() {
  docker run --rm -it -v "$PWD"/source:/source -v "$PWD"/dest:/dest -e SYNC_SRC="/source" -e SYNC_DEST="/dest" -e FORCE_SYNC=1 rclone-test
  assertTrue "[ -r ./dest/lorem.txt ]"
}

testEmptySourceDoNotDeleteExistingFilesInDest() {
  touch ./dest/other.txt
  docker run --rm -it -v "$PWD"/source:/empty-source -v "$PWD"/dest:/dest -e SYNC_SRC="/source" -e SYNC_DEST="/dest" -e FORCE_SYNC=1 rclone-test
  assertTrue "[ -r ./dest/other.txt ]"
}

. ./shunit2
