# svxlink-docker

SvxLink is a project that develops software targeting the ham radio community. It started out as an EchoLink application for Linux back in 2003 but has now evolved to be something much more advanced.

## About this fork

The original version was 5 years old so it was very out of date.
I took the build information from the main project and grafted onto this one.
My fork is optimized for Pi 4, but it should run on any Debian Linux. 

-- brian32768 **

## To do

Make the build into stage one and
run in stage 2 to reduce image size

Can I run in Alpine instead of Debian?

## Install Docker and Docker Compose

```console
$ apt-get install docker docker-compose
```

## Build and Run svxlink

Edit docker-compose.yml, 
build an image, 
and run it.

```console
$ docker-compose build
$ docker-compose up -d
```

## Volumes

- `./config/svxlink.conf:/etc/svxlink/svxlink.conf` Path to the svxlink.conf File
- `./config/ModuleEchoLink.conf:/etc/svxlink/svxlink.d/ModuleEchoLink.conf` Path to the ModuleEchoLink.conf File

## Run console svxlink
```console
$ docker exec -it svxlink screen -x svxlink
```

## Update image SVXLINK
```console
$ docker-compose build --no-cache
$ docker-compose up -d
```

## A basic docker-compose.yml file

```yml
version: '3'
services:
  svxlink:
    build:
      context: .
      dockerfile: Dockerfile
    tty: true
    stdin_open: true
    container_name: svxlink
    ports:
      - 5198:5198/udp
      - 5199:5199/udp
      - 5200:5200/tcp
#    environment:
#      - GIT_BRANCH=master # To build another branch than master
#      - NUM_CORES=8 # To use more than one CPU core when compiling
#      - GIT_URL=username@your.repo:/path/to/svxlink.git # To use a specific git repositoty instead of the default one
    volumes:
      - ./config/svxlink.conf:/etc/svxlink/svxlink.conf:ro
      - ./config/ModuleEchoLink.conf:/etc/svxlink/svxlink.d/ModuleEchoLink.conf:ro
#      - ./config/sounds:/usr/share/svxlink/sounds:ro
#      - ${HOME}/.gitconfig:/home/svxlink/.gitconfig:ro # To import your git config add (mileage may vary)
    devices:
      - /dev/snd:/dev/snd
      - /dev/gpiomem:/dev/gpiomem
    restart: unless-stopped
```

## Resources

[svxlink](https://svxlink.org)

This project was forked from https://github.copm/f4hlv/svxlink-docker

