FROM lonly/docker-alpine-python:3.6.3

ARG VERSION=3.6.3-ml
ARG BUILD_DATE
ARG VCS_REF

LABEL \
    maintainer="lonly197@qq.com" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.docker.dockerfile="/Dockerfile" \
    org.label-schema.license="Apache License 2.0" \
    org.label-schema.name="lonly/docker-alpine-python" \
    org.label-schema.url="https://github.com/lonly197" \
    org.label-schema.description="This is a Base and Clean Docker Image for Python Programming Language." \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/lonly197/docker-alpine-python" \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vendor="lonly197@qq.com" \
    org.label-schema.version=$VERSION \
    org.label-schema.schema-version="1.0"

# Install packages
RUN	set -x \
	## Update apk
	&& apk update \
    && apk add --no-cache --upgrade --virtual=build-dependencies ca-certificates g++ gfortran musl-dev python3-dev \
    ## Update ca-cert
    && update-ca-certificates \
    ## fix 'RuntimeError: Broken toolchain: cannot link a simple C program'
    && export ARCHFLAGS=-Wno-error=unused-command-line-argument-hard-error-in-future \
    ## Install Mache
    && pip install --upgrade --no-cache-dir numpy pandas scipy scikit-learn matploylib seaborn \
    ## Cleanup
    && apk del build-dependencies \
    && find /usr/lib/python3.*/ -name __pycache__ | xargs rm -r \
    && find /usr/lib/python3.*/ -name 'tests' -exec rm -r '{}' + \
    && rm -rf /root/.cache \
    && rm -rf *.tgz *.tar *.zip \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*