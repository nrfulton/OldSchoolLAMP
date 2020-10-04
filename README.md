# Dockerfile for LAMP Stack with PHP 5.6 and MySQL 5.6.31 

This is a bare install of very old versions of PHP and MySQL.
Be very careful about exposing ports from these Docker containers
and take extreme precautions before exposing one of these containers to the
public internet.

The intended use case of this Dockerfile is running legacy LAMP applications
in a controlled environment. In particular, I replicate some of the options
that were common in shared hosting envrionments during the late 2000s and 
early 2010s. 

## Setup

To use this Dockerfile, you must first download 
[MySQL 5.6.31 debs](https://dev.mysql.com/downloads/file/?id=496314).
Rename the tarball to `mysqlserver5.7.tar`.

## Building and Installing

To build the image:

```
docker image build -t oldlamp:v0 .
```

To start a container and expose its webserver on port 4444 on the host machine.

```
docker run --name oldlamp -p 127.0.0.1:4444:80 -itd oldlamp:v0 ./post_install.sh
```

And to drop to a shell:

```
docker exec -it oldlamp bash
```
