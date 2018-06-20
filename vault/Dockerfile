# base image
FROM vault:latest

WORKDIR /vault

VOLUME /vault/pki

RUN set -ex && \
   # add bash package
   apk add --no-cache bash openssl

# copy docker-entrypoint script
COPY ./docker-entrypoint.sh /vault
ENTRYPOINT [ "./docker-entrypoint.sh" ]
