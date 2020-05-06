#! /bin/bash

source $CKAN_VENV/bin/activate
rm -f Pipfile Pipfile.lock
pipenv install -r requirements.in
pipenv lock -r > requirements-freeze.pipenv.txt
pipenv graph
