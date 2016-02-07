#!/bin/bash
set -euo pipefail

# <nginx>
mkdir -p /var/lib/nginx
mkdir -p /var/log/nginx
rm -rf /var/run
mkdir -p /var/run
# </nginx>

# <www internal>
mkdir -p /var/internal-www
# </www>

# <python support>
mkdir -p /var/tmp
# </python>

# <test suite>
echo '<pre>' >> /var/internal-www/index.html
date -R >> /var/internal-www/index.html

function setup() {
  cd /tmp
  rm -rf "$1"
  git clone /opt/app/mediagoblin-unpacked "$1"
  cd "$1"
  virtualenv --system-site-packages .
  bin/pip install --editable . --no-index --find-links=/opt/app/wheelhouse
}

setup /var/writeable-gmg

( cd /var/writeable-gmg ; ./runtests.sh  >> /var/internal-www/index.html 2>&1 ; echo '</pre>' >> /var/internal-www/index.html ) &
# </test>

# Start nginx.
/usr/sbin/nginx -c /opt/app/.sandstorm/service-config/nginx.conf -g "daemon off;"
