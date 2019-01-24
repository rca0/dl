FROM alpine:3.8

WORKDIR /debug

RUN set -ex && \
    apk update && apk upgrade && \
    apk add --update --no-cache --virtual=build-dependencies \
    bash bash-doc bash-completion \
    udisks2 udisks2-doc shadow nodejs nodejs-npm \
    util-linux pciutils usbutils coreutils binutils findutils grep \
    vim curl wget nmap python-dev python3-dev postgresql-dev make \
    gcc automake autoconf tar unzip git && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    pip install pipenv --user && \
    curl https://sdk.cloud.google.com | bash && \
    npm install install elasticdump -g && \
    apk del --purge \
    build-dependencies && \
    rm -rf /root/.cache
