# base image
FROM vault:latest
MAINTAINER Ruan Arcega <ruan@arcega.com.br>

WORKDIR /vault

ENV CONFIG_DIR ${CONFIG_DIR:-/vault/config}
ENV PKI_DIR ${PKI_DIR:-/vault/pki}

RUN set -ex && \
   # add bash package
   apk add --no-cache bash openssl

VOLUME ${CONFIG_DIR}
VOLUME ${PKI_DIR}

# copy docker-entrypoint script
COPY ./docker-entrypoint.sh /vault
ENTRYPOINT [ "./docker-entrypoint.sh" ]
