# Agate Docker

This repository contains the source code for building an [Agate](https://www.obiba.org/pages/products/agate/) Docker image based on the [original Agate image from OBiBa](https://github.com/obiba/docker-agate), modified to:
* support the use of Docker secrets for passwords;
* connect to a MongoDB instance with enabled Access Control;
* automatically create custom Agate applications and groups.

## Building
After every commit, GitLab CI automatically builds the image and pushes it into INESC TEC's Docker Registry. The version tag of the image is determined from a string matching `##x.x.x##` on the commit message.

Alternatively, an image can be built locally by running:
`docker build -t agate-docker .`

## Setting Up
**Environment Variables**  
The following environment variables are available:

* `AGATE_ADMINISTRATOR_PASSWORD` is the password for the administrator account of the Agate server;
* `RECAPTCHA_SITE_KEY` and `RECAPTCHA_SECRET_KEY` are the reCAPTCHA keys required to enable the user 'sign up' functionality;
* `$MONGO_PORT_27017_TCP_ADDR` and `$MONGO_PORT_27017_TCP_PORT` are the address and port of the MongoDB server;
* `MONGO_INITDB_ROOT_USERNAME` and `MONGO_INITDB_ROOT_PASSWORD` are the credentials Agate will use to connect to the MongoDB server.

If you are using Docker Swarm, you can instead set the following variables to enable Docker secrets:
* `AGATE_ADMINISTRATOR_PASSWORD_FILE`
* `RECAPTCHA_SECRET_KEY_FILE`
* `MONGO_INITDB_ROOT_PASSWORD_FILE`

**Volumes**  
Volumes can be mounted to different parts of the container:
* `/usr/share/agate/applications` where you can place any Agate applications (JSON format) that you may want to add;
* `/usr/share/agate/groups` where you can place any Agate groups (JSON format) that you may want to add;
* `/srv` where data that should be persisted is stored.

## Running

Create a `docker-compose.yml` file (examples bellow) and run `docker-compuse up`.

**Basic Example:**
```yml
version: '3.2'

services:
  agate:
    image: docker-registry.inesctec.pt/coral/coral-docker-images/coral-agate-docker:1.2.0
    container_name: agate
    environment:
    - AGATE_ADMINISTRATOR_PASSWORD=<INSERT_VALUE_HERE>
    - RECAPTCHA_SITE_KEY=<INSERT_VALUE_HERE>
    - RECAPTCHA_SECRET_KEY=<INSERT_VALUE_HERE>
    - $MONGO_PORT_27017_TCP_ADDR=<INSERT_VALUE_HERE>
    - $MONGO_PORT_27017_TCP_PORT=<INSERT_VALUE_HERE>
    - MONGO_INITDB_ROOT_USERNAME=<INSERT_VALUE_HERE>
    - MONGO_INITDB_ROOT_PASSWORD=<INSERT_VALUE_HERE>
    volumes:
    - <PATH_TO_APPLICATIONS>:/usr/share/agate/applications
    - <PATH_TO_GROUPS>:/usr/share/agate/groups
    - agate:/srv

volumes:
  agate:
```
**Docker Swarm Example:**
```yml
version: '3.2'

services:
  agate:
    image: docker-registry.inesctec.pt/coral/coral-docker-images/coral-agate-docker:1.2.0
    container_name: agate
    environment:
    - AGATE_ADMINISTRATOR_PASSWORD_FILE=/run/secrets/AGATE_ADMINISTRATOR_PASSWORD
    - RECAPTCHA_SITE_KEY=<INSERT_VALUE_HERE>
    - RECAPTCHA_SECRET_KEY_FILE=/run/secrets/RECAPTCHA_SECRET_KEY
    - $MONGO_PORT_27017_TCP_ADDR=<INSERT_VALUE_HERE>
    - $MONGO_PORT_27017_TCP_PORT=<INSERT_VALUE_HERE>
    - MONGO_INITDB_ROOT_USERNAME=<INSERT_VALUE_HERE>
    - MONGO_INITDB_ROOT_PASSWORD_FILE=/run/secrets/MONGO_INITDB_ROOT_PASSWORD
    secrets:
    - AGATE_ADMINISTRATOR_PASSWORD
    - RECAPTCHA_SECRET_KEY
    - MONGO_INITDB_ROOT_PASSWORD
    volumes:
    - <PATH_TO_APPLICATIONS>:/usr/share/agate/applications
    - <PATH_TO_GROUPS>:/usr/share/agate/groups
    - agate:/srv

secrets:
  AGATE_ADMINISTRATOR_PASSWORD:
    external: true
  RECAPTCHA_SECRET_KEY:
    external: true
  MONGO_INITDB_ROOT_PASSWORD:
    external: true

volumes:
  agate:
```

<br>

---
master: [![pipeline status](https://gitlab.inesctec.pt/coral/coral-docker-images/coral-agate-docker/badges/master/pipeline.svg)](https://gitlab.inesctec.pt/coral/coral-docker-images/coral-agate-docker/commits/master)

dev: &emsp;&ensp;[![pipeline status](https://gitlab.inesctec.pt/coral/coral-docker-images/coral-agate-docker/badges/dev/pipeline.svg)](https://gitlab.inesctec.pt/coral/coral-docker-images/coral-agate-docker/commits/dev)
