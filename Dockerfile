FROM alpine:latest


RUN cd / && apk add --update tzdata && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone && \
    apk add uwsgi uwsgi-python && wget https://github.com/aploium/zmirror/archive/master.zip && unzip master.zip && rm master.zip && \
    chown -R uwsgi:uwsgi zmirror-master && pip3 install requests flask && \
    mkdir -p /etc/dropbear && apk add dropbear && rm -rf /var/cache/apk/*


ENV SSH_PORT=83 \
    PORT=80 \
    UWSGI_SOCKET_PORT=81 \
    UWSGI_STAT_PORT=82

EXPOSE ${HTTP_PORT} ${SSH_PORT} ${UWSGI_SOCKET_PORT} ${UWSGI_STAT_PORT}

COPY zmirror-uwsgi.tmpl entry.sh /

ENV SSH_PASSWORD='**changeme**' \
    DOMAIN='localhost' \
    SCHEME='https://' \
    VERBOSE_LEVEL=0 \
    UWSGI_NUM_PROCESS=2 \
    UWSGI_NUM_THREAD=1

CMD sh /entry.sh

