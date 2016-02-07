#!/bin/bash
set -euo pipefail

mkdir -p /var/lib/nginx
mkdir -p /var/log/nginx
# Wipe /var/run, since pidfiles and socket files from previous launches should go away
# TODO someday: I'd prefer a tmpfs for these.
rm -rf /var/run
mkdir -p /var/run

mkdir -p /var/tmp

mkdir -p /var/internal-www
echo '<pre>' >> /var/internal-www/index.html
date -R >> /var/internal-www/index.html
( cd /opt/app/mediagoblin-unpacked ; ./runtests.sh >> /var/internal-www/index.html 2>&1 ; echo '</pre>' >> /var/internal-www/index.html ) &

# Start nginx.
/usr/sbin/nginx -c /opt/app/.sandstorm/service-config/nginx.conf -g "daemon off;"
