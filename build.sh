#!/bin/bash

docker build --no-cache --build-arg RCLONE_VERSION=v1.47.0 -t pfidr/rclone:1.47 -t pfidr/rclone:1.47.0 .
docker build --no-cache --build-arg RCLONE_VERSION=v1.48.0 -t pfidr/rclone:1.48 -t pfidr/rclone:1.48.0 .
docker build --no-cache --build-arg RCLONE_VERSION=v1.49.0 -t pfidr/rclone:1.49.0 .
docker build --no-cache --build-arg RCLONE_VERSION=v1.49.1 -t pfidr/rclone:1.49.1 .
docker build --no-cache --build-arg RCLONE_VERSION=v1.49.2 -t pfidr/rclone:1.49.2 .
docker build --no-cache --build-arg RCLONE_VERSION=v1.49.3 -t pfidr/rclone:1.49.3 .
docker build --no-cache --build-arg RCLONE_VERSION=v1.49.4 -t pfidr/rclone:1.49.4 .
docker build --no-cache --build-arg RCLONE_VERSION=v1.49.5 -t pfidr/rclone:1.49.5 .
docker build --no-cache --build-arg RCLONE_VERSION=v1.50.0 -t pfidr/rclone:1.50.0 .
docker build --no-cache --build-arg RCLONE_VERSION=v1.50.1 -t pfidr/rclone:1.50.1 .
docker build --no-cache --build-arg RCLONE_VERSION=v1.50.2 -t pfidr/rclone:1.50.2 .
docker build --no-cache --build-arg RCLONE_VERSION=v1.51.0 -t pfidr/rclone:1.51.0 .
docker build --no-cache --build-arg RCLONE_VERSION=v1.52.0 -t pfidr/rclone:1.52.0 .
docker build --no-cache --build-arg RCLONE_VERSION=v1.52.1 -t pfidr/rclone:1.52.1 .
docker build --no-cache --build-arg RCLONE_VERSION=v1.52.2 -t pfidr/rclone:1.52.2 .
docker build --no-cache --build-arg RCLONE_VERSION=v1.52.3 -t pfidr/rclone:1.52.3 .
docker build --no-cache --build-arg RCLONE_VERSION=v1.53.0 -t pfidr/rclone:1.53.0 .
docker build --no-cache --build-arg RCLONE_VERSION=v1.53.1 -t pfidr/rclone:1.53.1 .
docker build --no-cache --build-arg RCLONE_VERSION=v1.53.2 -t pfidr/rclone:1.53.2 .
docker build --no-cache --build-arg RCLONE_VERSION=v1.53.3 -t pfidr/rclone:1.53.3 .
docker build --no-cache --build-arg RCLONE_VERSION=v1.53.4 -t pfidr/rclone:1.53.4 .
docker build --no-cache --build-arg RCLONE_VERSION=v1.54.0 -t pfidr/rclone:1.54.0 .
docker build --no-cache --build-arg RCLONE_VERSION=v1.54.1 -t pfidr/rclone:1.54.1 .
docker build --no-cache --build-arg RCLONE_VERSION=v1.55.0 -t pfidr/rclone:1.55.0 .
docker build --no-cache --build-arg RCLONE_VERSION=v1.55.1 -t pfidr/rclone:1.55.1 -t pfidr/rclone:latest -t pfidr/rclone:test -t rclone_test .
