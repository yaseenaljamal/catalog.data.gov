# CKAN requirements management sandbox

## setup

* Docker

* create a file `.env` that looks like:

  ```
  UID=1000:1000
  ```
  where you replace `1000:1000` with your logged in user's uid and gid.

* Run `docker-compose build`

## what's here?

Examples of installing and freezing CKAN requirements using four methods:

1. pip install and pip freeze
2. pip-compile (from pip-tools)
3. pipenv
4. poetry

All the examples start with a `requirements.in` file that was
extracted from the `ckan/ckan` GitHub repo (tagged *ckan-2.8.4*).  I
made two changes:

- I added `ckan==2.8.4` so that CKAN itself would be installed
- I added a requirement for PasteScript (`==2.0.2`) because several of
  the tools couldn't find a version of PasteScript that met all the
  package requirements w/o it.

Each example is provided as Docker compose service that reads the
requirements.in file and generates a frozen requirements file.  You
can run an example ala:

```sh
docker-compose run ckan-pipenv
```

The script `test.sh` runs all the examples using Docker.  Each example
produces a frozen requirements file for your enjoyment (I've taken the liberty
of checking these in to the branch so you can look at them without needing
to run the examples.  I've also included the poetry and pipenv configuration files.)

1. `requirements-freeze.pip.txt`
2. `requirements-freeze.pip-tools.txt`
3. `requirements-freeze.pipenv.txt`
4. `requirements-freeze.poetry.txt`

Finally, in a fresh virtual enviornment, each frozen requirements file
is loaded by pip to demonstrate a kind of success.
