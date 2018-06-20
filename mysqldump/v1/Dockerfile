FROM alpine:3.7

COPY dump.sh /usr/local/bin/dump
COPY import.sh /usr/local/bin/import
COPY docker-entrypoint.sh /usr/local/bin/

RUN set -ex && \
    apk add --update --no-cache mysql-client bash openssh-client && \
    rm -rf /docker-entrypoint.sh && \
    ln -s /usr/local/bin/docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["dump"]
