#!/bin/bash

# Install any local extensions in the src_extensions volume
echo "Looking for local extensions to install..."
echo "Extension dir contents:"
ls -la $SRC_EXTENSIONS_DIR
for i in $SRC_EXTENSIONS_DIR/*
do
    if [ -d $i ];
    then

        if [ -f $i/pip-requirements.txt ];
        then
            pip install -r $i/pip-requirements.txt
            echo "Found requirements file in $i"
        fi
        if [ -f $i/requirements.txt ];
        then
            pip install -r $i/requirements.txt
            echo "Found requirements file in $i"
        fi
        if [ -f $i/setup.py ];
        then
            cd $i
            python $i/setup.py develop
            echo "Found setup.py file in $i"
            cd $APP_DIR
        fi
    fi
done

# Update the plugins setting in the ini file with the values defined in the env var
echo "Loading the following plugins: $CKAN__PLUGINS"
paster --plugin=ckan config-tool $CKAN_INI "ckan.plugins = $CKAN__PLUGINS"

# Update test-core.ini DB, SOLR & Redis settings
echo "Loading test settings into test-core.ini"
paster --plugin=ckan config-tool $SRC_DIR/ckan/test-core.ini "sqlalchemy.url = postgresql://ckan:ckan@db/ckan_test"
paster --plugin=ckan config-tool $SRC_DIR/ckan/test-core.ini "ckan.datstore.write_url = postgresql://ckan:ckan@db/datastore_test"
paster --plugin=ckan config-tool $SRC_DIR/ckan/test-core.ini "ckan.datstore.read_url = postgresql://datastore_ro:datastore@db/datastore_test"

paster --plugin=ckan config-tool $SRC_DIR/ckan/test-core.ini "solr_url = http://solr:8983/solr/ckan"
paster --plugin=ckan config-tool $SRC_DIR/ckan/test-core.ini "ckan.redis_url = redis://redis:6379/1"

# Run the prerun script to init CKAN and create the default admin user
python prerun.py

# Start the development server with automatic reload
paster serve --reload $CKAN_INI

