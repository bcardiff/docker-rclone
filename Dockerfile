ARG BASE=alpine:latest
FROM ${BASE}

LABEL maintainer="pfidr"

ARG RCLONE_VERSION=current
ARG ARCH=amd64
ENV SYNC_SRC=
ENV SYNC_DEST=
ENV SYNC_OPTS=-v
ENV SYNC_OPTS_EVAL=
ENV SYNC_ONCE=
ENV RCLONE_CMD=sync
ENV RCLONE_DIR_CMD=ls
ENV RCLONE_DIR_CMD_DEPTH=-1
ENV RCLONE_DIR_CHECK_SKIP=
ENV RCLONE_OPTS="--config /config/rclone.conf"
ENV OUTPUT_LOG=
ENV ROTATE_LOG=
ENV CRON=
ENV CRON_ABORT=
ENV FORCE_SYNC=
ENV CHECK_URL=
ENV FAIL_URL=
ENV TZ=
ENV UID=
ENV GID=

RUN apk --no-cache add ca-certificates fuse wget dcron tzdata

RUN URL=http://downloads.rclone.org/${RCLONE_VERSION}/rclone-${RCLONE_VERSION}-linux-${ARCH}.zip ; \
  URL=${URL/\/current/} ; \
  cd /tmp \
  && wget -q $URL \
  && unzip /tmp/rclone-${RCLONE_VERSION}-linux-${ARCH}.zip \
  && mv /tmp/rclone-*-linux-${ARCH}/rclone /usr/bin \
  && rm -r /tmp/rclone*

COPY entrypoint.sh /
COPY sync.sh /
COPY sync-abort.sh /

VOLUME ["/config"]
VOLUME ["/logs"]

ENTRYPOINT ["/entrypoint.sh"]

CMD [""]
