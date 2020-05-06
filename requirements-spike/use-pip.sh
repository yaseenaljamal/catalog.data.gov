#! /bin/bash

source $CKAN_VENV/bin/activate
pip install -r requirements.in
pip freeze > requirements-freeze.pip.txt
