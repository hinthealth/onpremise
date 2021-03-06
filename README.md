# Sentry Nightly On-Premise [![Build Status][build-status-image]][build-status-url]

Official bootstrap for running your own [Sentry](https://sentry.io/) with [Docker](https://www.docker.com/).

## Requirements

 * Docker 17.05.0+
 * Compose 1.23.0+

## Minimum Hardware Requirements:

 * You need at least 2400MB RAM

## Setup

To get started with all the defaults, simply clone the repo and run `./install.sh` in your local check-out.

There may need to be modifications to the included example config files (`sentry/config.example.yml` and `sentry/sentry.conf.example.py`) to accommodate your needs or your environment (such as adding GitHub credentials). If you want to perform these, do them before you run the install script and copy them without the `.example` extensions in the name (such as `sentry/sentry.conf.py`) before running the `install.sh` script.

The recommended way to customize your configuration is using the files below, in that order:

 * `config.yml`
 * `sentry.conf.py`
 * `.env` w/ environment variables

We currently support a very minimal set of environment variables to promote other means of configuration.

If you have any issues or questions, our [Community Forum](https://forum.sentry.io/c/on-premise) is at your service! Everytime you run the install script, it will generate a log file, `sentry_install_log-<ISO_TIMESTAMP>.txt` with the output. Sharing these logs would help people diagnose any issues you might be having.

## Versioning

If you want to install a specific release of Sentry, use the tags/releases on this repo.

We continously push the Docker image for each commit made into [Sentry](https://github.com/getsentry/sentry), and other services such as [Snuba](https://github.com/getsentry/snuba) or [Symbolicator](https://github.com/getsentry/symbolicator) to [our Docker Hub](https://hub.docker.com/u/getsentry) and tag the latest version on master as `:latest`. This is also usually what we have on sentry.io and what the install script uses. You can use a custom Sentry image, such as a modified version that you have built on your own, or simply a specific commit hash by setting the `SENTRY_IMAGE` environment variable to that image name before running `./install.sh`:

```shell
SENTRY_IMAGE=getsentry/sentry:83b1380 ./install.sh
```

Note that this may not work for all commit SHAs as this repository evolves with Sentry and its satellite projects. It is highly recommended to check out a version of this repository that is close to the timestamp of the Sentry commit you are installing.

## Event Retention

Sentry comes with a cleanup cron job that prunes events older than `90 days` by default. If you want to change that, you can change the `SENTRY_EVENT_RETENTION_DAYS` environment variable in `.env` or simply override it in your environment. If you do not want the cleanup cron, you can remove the `sentry-cleanup` service from the `docker-compose.yml`file.

## Securing Sentry with SSL/TLS

If you'd like to protect your Sentry install with SSL/TLS, there are
fantastic SSL/TLS proxies like [HAProxy](http://www.haproxy.org/)
and [Nginx](http://nginx.org/). You'll likely want to add this service to your `docker-compose.yml` file.

## Updating Sentry

_You need to be on at least Sentry 9.1.2 to be able to upgrade automatically to the latest version. If you are not, upgrade to 9.1.2 first by checking out the [9.1.2 tag](https://github.com/getsentry/onpremise/tree/9.1.2) on this repo._

The included `install.sh` script is meant to be idempotent and to bring you to the latest version. What this means is you can and should run `install.sh` to upgrade to the latest version available. Remember that the output of the script will be stored in a log file, `sentry_install_log-<ISO_TIMESTAMP>.txt`, which you may share for diagnosis if anything goes wrong.

## Resources

 * [Documentation](https://docs.sentry.io/development/server/)
 * [Bug Tracker](https://github.com/getsentry/onpremise/issues)
 * [Community Forums](https://forum.sentry.io/c/on-premise)

## On Aptible

### Setup

- Create a new pg db, ex: `hint-sentry-pg-v8.20`
- Create a new redis db, ex: `hint-sentry-redis-v8.20`
- Create a new app, ex: `hint-sentry-v8.20`
- Follow the steps to ##Deploy
- Ssh into the Aptible's app (`aptible ssh --app hint-sentry-v8.20`) and generate a new secret key (`sentry config generate-secret-key`)
- Set the required env variables:
  For version 8.20 those are:
  - SENTRY_DB_NAME
  - SENTRY_DB_PASSWORD
  - SENTRY_DB_USER
  - SENTRY_EMAIL_HOST, suggested value: `smtp.mailgun.org`
  - SENTRY_EMAIL_PASSWORD
  - SENTRY_EMAIL_USER, suggested value: `postmaster@mailsentry.hint.com`
  - SENTRY_POSTGRES_HOST
  - SENTRY_POSTGRES_PORT
  - SENTRY_REDIS_HOST
  - SENTRY_REDIS_PASSWORD
  - SENTRY_REDIS_PORT
  - SENTRY_SECRET_KEY
  - SENTRY_SERVER_EMAIL, suggested value: `sentry@hint.com`
  - SENTRY_SINGLE_ORGANIZATION, suggested value: `true`
  - SENTRY_URL_PREFIX
  - SENTRY_USE_SSL, suggested value: `true`
- Login to the Aptible app via ssh and execute: `sentry upgrade`

### Deploy

- Clone this repository `git clone git@github.com:hinthealth/onpremise.git`
- Add the Aptible's remote, ex: `git remote add aptible git@beta.aptible.com:hint-production/hint-sentry-v8.20.git`
- Push the code to the Aptible's remote

### Upgrade

- Update this repo against upstream (`getsentry/onpremise`), if any conflicts where to happen it would only
be on this README.
- Add any new required env variables
- Backup database just in case the upgrade fails you need to rollback
- Follow the steps to ##Deploy
- Login to the Aptible app via ssh and execute: `sentry upgrade`

[build-status-image]: https://api.travis-ci.com/getsentry/onpremise.svg?branch=master
[build-status-url]: https://travis-ci.com/getsentry/onpremise
