#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y nginx
service nginx stop
systemctl disable nginx

## Install GMG dependencies
sudo apt-get install -y git-core python python-dev python-lxml python-imaging python-virtualenv libjpeg-dev autoconf nodejs npm nodejs-legacy python-gst-1.0 gstreamer1.0-plugins-base gstreamer1.0-plugins-bad gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-libav python-numpy python-scipy libsndfile1-dev libasound2-dev libgstreamer-plugins-base1.0-dev
