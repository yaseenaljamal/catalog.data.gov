#! /bin/bash

source $CKAN_VENV/bin/activate
rm -f pyproject.toml poetry.lock
poetry init -n --name "catalog.data.gov" $(cat requirements.in | xargs -n 1 echo --dependency)
poetry export -f requirements.txt -o requirements-freeze.poetry.txt --without-hashes
poetry show --tree




