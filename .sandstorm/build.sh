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

# <python>
# We actually do 'pip install' etc. into a virtualenv we create during launcher.sh. Rationale:
#
# - pytest needs its virtualenv to be writeable, see https://github.com/pytest-dev/pytest/issues/1342
#
# - launcher.sh has a writeable /var but by contrast everything created by build.sh ends up read-only
#   when the grain runs.
#
# - build.sh has Internet access, but launcher.sh does not. (Well launcher.sh *kinda* does via
#   httpGet but that is a huge pain.)
#
# To support that, we find out the list of Python dependencies and create local wheels for them. This
# allows `pip install` to occur within the Internet-less system and still succeed.

# Get MediaGoblin ready
if [ -e /opt/app/wheelhouse/mediagoblin*whl ] ; then
  exit 0  # we already succeeded before
fi
cd /opt/app/mediagoblin-unpacked
./bootstrap.sh
./configure

rm -f bin/python bin/python2
virtualenv --system-site-packages --python=python2 .

mkdir -p /opt/app/wheelhouse

# Since we have pip from Debian, let us get wheel from Debian as well.
sudo apt-get install python-wheel

bin/pip wheel --wheel-dir=/opt/app/wheelhouse .

# </python>

# FIXME: We might need to do the same with extlib, but then again, we can probably avoid doing it since
# the tests are pure Python.

exit 0
