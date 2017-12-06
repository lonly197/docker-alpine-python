FROM lonly/docker-alpine:3.6-slim

ARG VERSION=3.6.3
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
    ## Define variant
    && PYTHON_VERSION=${VERSION} \
    && PIP_VERSION=9.0.1 \
    && GPG_KEY=0D96DF4D4110E5C43FBFB17F2D347EA6AA65421D \
    ## Update apk
    && apk update \
    ## Install base package
    && apk add --no-cache --upgrade --virtual=build-dependencies gnupg libressl xz \
    ## Download python pacage
    && wget -q -c -O python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" \
	&& wget -q -c -O python.tar.xz.asc "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz.asc" \
    ## Verify python package
    && export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPG_KEY" \
	&& gpg --batch --verify python.tar.xz.asc python.tar.xz \
	&& rm -rf "$GNUPGHOME" python.tar.xz.asc \
    ## Install python
    && mkdir -p /usr/src/python \
	&& tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz \
	&& rm python.tar.xz \
    ## Install python build dependencies package
    && apk add --no-cache --virtual=build-dependencies  \
		bzip2-dev \
		coreutils \
		dpkg-dev dpkg \
		expat-dev \
		gcc \
		gdbm-dev \
		libc-dev \
		libffi-dev \
		linux-headers \
		make \
		ncurses-dev \
		libressl \
		libressl-dev \
		pax-utils \
		readline-dev \
		sqlite-dev \
		tcl-dev \
		tk \
		tk-dev \
		xz-dev \
		zlib-dev \
    ## Add build deps before removing fetch deps in case there's overlap
	# && apk del build-dependencies \
    ## Make and  install python
    && cd /usr/src/python \
	&& gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
	&& ./configure \
		--build="$gnuArch" \
		--enable-loadable-sqlite-extensions \
		--enable-shared \
		--with-system-expat \
		--with-system-ffi \
		--without-ensurepip \
	&& make -j "$(nproc)" \
	&& make install \
	&& runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)" \
	&& apk add --virtual .python-rundeps $runDeps \
    && find /usr/local -depth \
		\( \
			\( -type d -a \( -name test -o -name tests \) \) \
			-o \
			\( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
		\) -exec rm -rf '{}' + \
	&& rm -rf /usr/src/python \
    ## Make some useful symlinks that are expected to exist
    && cd /usr/local/bin \
	&& ln -s idle3 idle \
	&& ln -s pydoc3 pydoc \
	&& ln -s python3 python \
	&& ln -s python3-config python-config \
    ## Download pip
    && wget -q -c -O  get-pip.py 'https://bootstrap.pypa.io/get-pip.py' \
    ## Install pip
    && python get-pip.py \
		--disable-pip-version-check \
		--no-cache-dir \
		"pip==$PIP_VERSION" \
    && find /usr/local -depth \
		\( \
			\( -type d -a \( -name test -o -name tests \) \) \
			-o \
			\( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
		\) -exec rm -rf '{}' + \
	&& rm -rf get-pip.py \
    ## Add pip repo
    && mkdir ~/.pip \
    && printf $'[global] \nindex-url = http://mirrors.aliyun.com/pypi/simple/ \n[install] \ntrusted-host=mirrors.aliyun.com \ndisable-pip-version-check = true \ntimeout = 6000' >> ~/.pip/pip.conf \
    ## Cleanup
    && apk del build-dependencies \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*