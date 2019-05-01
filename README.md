# docker-rclone

Docker image to perform a [rclone](http://rclone.org) sync based on a cron schedule, with [healthchecks.io](https://healthchecks.io) monitoring.

rclone is a command line program to sync files and directories to and from:

* Google Drive
* Amazon S3
* Openstack Swift / Rackspace cloud files / Memset Memstore
* Dropbox
* Google Cloud Storage
* Amazon Drive
* Microsoft OneDrive
* Hubic
* Backblaze B2
* Yandex Disk
* SFTP
* FTP
* HTTP
* The local filesystem

## Usage

### Configure rclone

rclone needs a configuration file where credentials to access different storage
provider are kept.

By default, this image uses a file `/config/rclone.conf` and a mounted volume may be used to keep that information persisted.

A first run of the container can help in the creation of the file, but feel free to manually create one.

```
$ mkdir config
$ docker run --rm -it -v $(pwd)/config:/config pfidr34/rclone
```

### Perform sync in a daily basis

A few environment variables allow you to customize the behavior of the sync:

* `SYNC_SRC` source location for `rclone sync/copy` command
* `SYNC_DEST` destination location for `rclone sync/copy` command
* `SYNC_OPTS` additional options for `rclone sync/copy` command. Defaults to `-v`
* `RCLONE_CMD` set variable to `sync` or `copy` when running rclone. Defaults to `sync`
* `RCLONE_DIR_CMD` set variable to `ls` or `lsf` for source directory check style. Defaults to `ls`
* `RCLONE_DIR_CHECK_SKIP` set variable to skip source directory check before sync. *Use with caution*
* `CRON` crontab schedule `0 0 * * *` to perform sync every midnight. Also supprorts cron shortcuts: `@yearly` `@monthly` `@weekly` `@daily` `@hourly`
* `CRON_ABORT` crontab schedule `0 6 * * *` to abort sync at 6am
* `FORCE_SYNC` set variable to perform a sync upon boot
* `CHECK_URL` [healthchecks.io](https://healthchecks.io) url or similar cron monitoring to perform a `GET` after a successful sync
* `SYNC_OPTS` additional options for `rclone sync` command. Defaults to `-v`
* `OUTPUT_LOG` set variable to output log file to /logs
* `TZ` set the [timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) to use for the cron and log `America/Chicago`

```bash
$ docker run --rm -it -v $(pwd)/config:/config -v /path/to/source:/source -e SYNC_SRC="/source" -e SYNC_DEST="dest:path" -e TZ="America/Chicago" -e CRON="0 0 * * *" -e CRON_ABORT="0 6 * * *" -e FORCE_SYNC=1 -e CHECK_URL=https://hchk.io/hchk_uuid pfidr34/rclone
```

See [rclone sync docs](https://rclone.org/commands/rclone_sync/) for source/dest syntax and additional options.


**Credit to Brian J. Cardiff for the orginal project @ https://github.com/bcardiff/docker-rclone**
