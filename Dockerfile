FROM alpine:latest

RUN cd / && apk add --update tzdata && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone && \
    apk add uwsgi uwsgi-python && pip3 install requests flask && \
    mkdir -p /etc/dropbear && apk add dropbear && rm -rf /var/cache/apk/*

ENV PORT=80 \
    SSH_PORT=8022 \
    UWSGI_SOCKET_PORT=8000 \
    UWSGI_STAT_PORT=8001

EXPOSE ${PORT} ${SSH_PORT} ${UWSGI_SOCKET_PORT} ${UWSGI_STAT_PORT}

COPY zmirror-master-20200225.zip zmirror-uwsgi.tmpl entry.sh /

RUN unzip zmirror-master-20200225.zip && rm zmirror-master-20200225.zip && chown -R uwsgi:uwsgi zmirror-master && \
    chmod +x entry.sh

ENV SSH_PASSWORD='**changeme**' \
    DOMAIN='localhost' \
    SCHEME='https://' \
    VERBOSE_LEVEL=0 \
    UWSGI_NUM_PROCESS=2 \
    UWSGI_NUM_THREAD=1

CMD /entry.sh

