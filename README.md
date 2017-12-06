# docker-alpine-python

> This Docker Image for building or running Python  applications, which basee on Alpine.

![Logo](https://raw.githubusercontent.com/docker-library/docs/01c12653951b2fe592c1f93a13b4e289ada0e3a1/python/logo.png)

## Introduction

> Please use corresponding branches from this repo to play with code.

- __3.6.3 = 3.6 = 3 = latest__
- __3.6.3-slim = 3.6-slim = 3-slim__

## Usage

Create a Dockerfile in your Python app 

```docker
FROM lonly/docker-alpine-python:3

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python", "./your-daemon-or-script.py" ]
```

You can then build and run the Docker image:

```bash
docker build -t my-python-app .
docker run -it --rm --name my-running-app my-python-app
```

Also, for many simple, single file projects, you may find it inconvenient to write a complete Dockerfile. In such cases, you can run a Python script by using the Python Docker image directly:

```bash
docker run -it --rm --name my-running-script -v "$PWD":/usr/src/myapp -w /usr/src/myapp python:3 python your-daemon-or-script.py
```

## License

![License](https://img.shields.io/github/license/lonly197/docker-alpine-python.svg)

## Contact me

- Email: <lonly197@qq.com>