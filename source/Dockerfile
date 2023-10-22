FROM alpine:3

RUN true \
    && apk upgrade --no-cache \
    && apk add --no-cache busybox-suid ffmpeg loksh \
    && mkdir -p /config /data \
    && touch /config/cameras.txt \
    && rm -rf /etc/periodic /etc/crontabs/root

COPY docker-entrypoint render.sh snap.sh /usr/local/bin/
COPY conf.sh /config/

ENTRYPOINT ["docker-entrypoint"]
CMD ["crond", "-f", "-d", "8"]

STOPSIGNAL SIGINT
