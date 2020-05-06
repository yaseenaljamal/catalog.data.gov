#! /bin/bash

source $CKAN_VENV/bin/activate
pip-compile --output-file requirements-freeze.pip-tools.txt requirements.in
