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

# It used to be the case that we thought we wanted a tarball install of GMG...
# ...but GMG from tarball seems to fail its tests, so that is no use. Getting from
# git...
if [ ! -d /opt/app/mediagoblin-unpacked ] ; then
  git clone http://git.savannah.gnu.org/cgit/mediagoblin.git/ /opt/app/mediagoblin-unpacked
  cd /opt/app/mediagoblin-unpacked
  echo ""
  echo "TODO: For now, you are going to have to work around one test failure, see IRC logs"
  echo ""
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

# Note: We ignore extlib, since the GMG test suite only tests Python code.

exit 0
