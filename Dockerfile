FROM lonly/alpine:3.6-slim

ARG VERSION=3.6-slim
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

# Define environment 
## Ensure local python is preferred over distribution python
ENV	PATH=/usr/local/bin:$PATH \
    ## http://bugs.python.org/issue19846
    ## > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
    LANG=C.UTF-8

# Install packages
RUN	set -x \
    ## Define Variant
    && PYTHON_VERSION=3.6.3-r9 \
    ## Install Python package
    && apk add --no-cache --upgrade  --repository http://mirrors.ustc.edu.cn/alpine/v3.6/edge/ --allow-untrusted python3 \
    && python3 -m ensurepip \
    && rm -r /usr/lib/python*/ensurepip \
    && pip3 install --upgrade pip setuptools \
    && if [[ ! -e /usr/bin/pip ]]; then ln -s pip3 /usr/bin/pip ; fi \
    && if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi \
    ## Cleanup
    && rm -rf /root/.cache \
    && rm -rf *.tgz *.tar *.zip \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*