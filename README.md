# Sentry On-Premise

Official bootstrap for running your own [Sentry](https://sentry.io/) with [Docker](https://www.docker.com/).

## Requirements

 * Docker 1.10.0+
 * Compose 1.6.0+ _(optional)_

## Up and Running

Assuming you've just cloned this repository, the following steps
will get you up and running in no time!

There may need to be modifications to the included `docker-compose.yml` file to accommodate your needs or your environment. These instructions are a guideline for what you should generally do.

1. `docker volume create --name=sentry-data && docker volume create --name=sentry-postgres` - Make our local database and sentry volumes
    Docker volumes have to be created manually, as they are declared as external to be more durable.
2. `cp -n .env.example .env` - create env config file
3. `docker-compose build` - Build and tag the Docker services
4. `docker-compose run --rm web config generate-secret-key` - Generate a secret key.
    Add it to `.env` as `SENTRY_SECRET_KEY`.
5. `docker-compose run --rm web upgrade` - Build the database.
    Use the interactive prompts to create a user account.
6. `docker-compose up -d` - Lift all services (detached/background mode).
7. Access your instance at `localhost:9000`!

## Securing Sentry with SSL/TLS

If you'd like to protect your Sentry install with SSL/TLS, there are
fantastic SSL/TLS proxies like [HAProxy](http://www.haproxy.org/)
and [Nginx](http://nginx.org/).

## Updating Sentry

Updating Sentry using Compose is relatively simple. Just use the following steps to update. Make sure that you have the latest version set in your Dockerfile. Or use the latest version of this repository.

Use the following steps after updating this repository or your Dockerfile:
```sh
docker-compose build # Build the services again after updating
docker-compose run --rm web upgrade # Run new migrations
docker-compose up -d # Recreate the services
```

## Resources

 * [Documentation](https://docs.sentry.io/server/installation/docker/)
 * [Bug Tracker](https://github.com/getsentry/onpremise)
 * [Forums](https://forum.sentry.io/c/on-premise)
 * [IRC](irc://chat.freenode.net/sentry) (chat.freenode.net, #sentry)

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
- Follow the steps to ##Deploy
- Login to the Aptible app via ssh and execute: `sentry upgrade`
