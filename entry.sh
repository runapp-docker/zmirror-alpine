#!/bin/sh
HLINE='------------------------------------------------'
echo $HLINE
echo Running under user $USER
echo "$USER:${SSH_PASSWORD}" | chpasswd
echo $HLINE
/usr/sbin/dropbear -REp ${SSH_PORT}
echo $HLINE
cat zmirror-uwsgi.tmpl - >> zmirror-uwsgi.ini <<EOF
processes = ${UWSGI_NUM_PROCESS}
threads = ${UWSGI_NUM_THREAD}
http-socket = :${PORT}
socket = :${UWSGI_SOCKET_PORT}
stats = :${UWSGI_STAT_PORT}
EOF
cat zmirror-master/more_configs/config_google_and_zhwikipedia.py - >> zmirror-master/config.py <<EOF
my_host_name = '${DOMAIN}'
my_host_scheme = '${SCHEME}'
url_custom_redirect_list['/scholar']='/extdomains/scholar.google.com/'
verbose_level = ${VERBOSE_LEVEL}
EOF
cat zmirror-uwsgi.ini
echo $HLINE
cat zmirror-master/config.py
echo $HLINE
uwsgi zmirror-uwsgi.ini
