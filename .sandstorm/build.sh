#!/bin/bash
set -euo pipefail
cd /opt/app
# This is a script that is run every time you call "vagrant-spk dev".
# It is intended to do platform-and-repository-specific build steps.  You
# might customize it to do any of the following, or more:
# - for Python, prepare a virtualenv and pip install -r requirements.txt
# - for PHP, call composer to retrieve additional packages
# - for JS/CSS/SASS/LESS, compile, minify, or otherwise do asset pipeline work.
# This particular script does nothing at present, but you should adapt it
# sensibly for your package.

if [ ! -f /opt/app/gmg.tar.gz ] ; then
  echo "Downloading GMG tarball..."
  wget -q http://mediagoblin.org/download/mediagoblin-0.8.1.tar.gz -O /opt/app/gmg.tar.gz.tmp
  mv /opt/app/gmg.tar.gz.tmp /opt/app/gmg.tar.gz
  echo "done."
  echo ""
fi

if [ ! -d /opt/app/mediagoblin-unpacked ] ; then
  echo "Unpacking..."
  mkdir -p mediagoblin-unpacked.tmp
  cd mediagoblin-unpacked.tmp
  tar zxf /opt/app/gmg.tar.gz
  mv mediagoblin-0.8.1 /opt/app/mediagoblin-unpacked
  echo "done."
  echo ""
fi

cd /opt/app/mediagoblin-unpacked
./bootstrap.sh
./configure
#make

exit 0
