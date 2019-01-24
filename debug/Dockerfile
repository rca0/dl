FROM alpine:3.8

RUN set -ex && \
    apk add --update --no-cache --virtual=build-dependencies bash \
    vim \
    curl \
    wget \
    nmap \
    python-dev \
    python3-dev \
    openssl-dev \
    make \
    gcc \
    automake \
    autoconf \
    tar \
    unzip \
    git && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    pip install pipenv --user && \
    curl https://sdk.cloud.google.com | bash && \
    apk del --purge \
    build-dependencies && \
    rm -rf /root/.cache 
