#! /bin/bash

source $CKAN_VENV/bin/activate
pip install -r requirements.in
pip install git+https://github.com/ckan/ckan.git@ckan-2.8.4
pip freeze > requirements-freeze.pip.txt
