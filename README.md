# svxlink-docker

SvxLink is a project that develops software targeting the ham radio
community. It started out as an EchoLink application for Linux back in
2003 but has now evolved to be something much more advanced.

This project builds svxlink in a docker container; that includes
svxreflector. It will work on either a x64 system or a Raspberry Pi.

## About this fork

The original version was 5 years old so it was very out of date.
I took the build information from the main project and grafted onto this one.
My fork is optimized for Pi 4, but it should run on any Debian Linux. 

-- brian32768 **

## To do

Make the build in stage 1 and
run in stage 2 to reduce image size

Can I run in Alpine instead of Debian?

## Install Docker and Docker Compose

```console
$ sudo apt install docker docker-compose
```

## Build and Run svxlink on a Raspberry Pi

(Taths; how I do it anyway.)

Edit docker-compose.svxlink.yml, 
build an image, 
and run it.

```console
$ docker-compose --file=docker-compose.svxlink.yml build
$ docker-compose --file=docker-compose.svxlink.yml up -d
```

I need to test so I also can run like this,

```bash
docker run -it --name=svxlink \
  -v `pwd`/config/svxlink.conf:/etc/svxlink/svxlink.conf \
  svxlink:latest bash
```

## Volumes

- `./config/svxlink.conf:/etc/svxlink/svxlink.conf` Path to the svxlink.conf file, for the svxlink only
- `./config/svxreflector.conf:/etc/svxlink/svxreflector.conf` Path to the svxreflector.conf file, for the reflector only
- `./config/ModuleEchoLink.conf:/etc/svxlink/svxlink.d/ModuleEchoLink.conf` Path to the ModuleEchoLink.conf File, only needed by svxlink.

## Run console svxlink
```console
$ docker exec -it svxlink screen -x svxlink
```

## Update image SVXLINK
```console
$ docker-compose build --no-cache
$ docker-compose up -d
```

## SVXreflector

The svxreflector runs on a VPS which has relatively limited resources
and the build step hits it pretty hard, so I do the build of the image
on a build machine with 32GB of RAM in it. Then copy the image to the VPS.

```bash
docker-compose --file=docker-compose.svxreflector.yml build
docker save -o svxlink.docker svxlink
scp svxlink.docker tarra.link:
```

On the VPS, load the copied image into the collection of images.

```bash
ssh tarra
docker load -i svxlink.docker
```

## Resources

[svxlink](https://svxlink.org)

This project was forked from https://github.copm/f4hlv/svxlink-docker

