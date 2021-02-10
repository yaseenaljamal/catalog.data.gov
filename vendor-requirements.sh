#!/bin/bash

set -o errexit
set -o pipefail

# Install any packaged dependencies for our vendored packages
sudo apt-get -y update
sudo apt-get -y install swig build-essential python-dev libssl-dev

pip install --upgrade --user pip wheel setuptools
pip download -r requirements.txt --no-binary=:none: -d vendor --exists-action=w
pip wheel -r requirements.txt -w vendor --no-binary=:none:
