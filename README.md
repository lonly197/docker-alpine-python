# docker-alpine-python

> This Docker Image for building or running Python  applications, basee on Alpine.

## Build

```bash
docker build --build-arg VCS_REF=`git rev-parse --short HEAD` \
--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
--rm \
-t lonly/docker-alpine-python:3.6.3-ml .
```

## Usage

```bash
docker run --rm frolvlad/alpine-python3 python3 -c 'print("Hello World")'
```

Once you have run this command you will get printed 'Hello World' from Python!

> pip/pip3 is also available in this image.

