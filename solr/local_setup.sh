#!/bin/bash

set -e

# Setup ckan core config
# Copies necessary bits from /app/solr/solr_setup.sh
mkdir -p /tmp/ckan_config

# add solr config files for ckan 2.9
wget -O /tmp/ckan_config/schema.xml https://raw.githubusercontent.com/GSA/catalog.data.gov/main/ckan/setup/solr/managed-schema
wget -O /tmp/ckan_config/protwords.txt https://raw.githubusercontent.com/GSA/catalog.data.gov/main/ckan/setup/solr/protwords.txt
wget -O /tmp/ckan_config/solrconfig.xml https://raw.githubusercontent.com/GSA/catalog.data.gov/main/ckan/setup/solr/solrconfig.xml
wget -O /tmp/ckan_config/solrconfig_follower.xml https://raw.githubusercontent.com/GSA/catalog.data.gov/main/ckan/setup/solr/solrconfig_follower.xml
wget -O /tmp/ckan_config/stopwords.txt https://raw.githubusercontent.com/GSA/catalog.data.gov/main/ckan/setup/solr/stopwords.txt
wget -O /tmp/ckan_config/synonyms.txt https://raw.githubusercontent.com/GSA/catalog.data.gov/main/ckan/setup/solr/synonyms.txt

# Check if users already exist
SECURITY_FILE=/var/solr/data/security.json
if [ -f "$SECURITY_FILE" ]; then
    echo "Solr authentication are set up already :)"
    exit 0;
fi

# add solr authentication
cat <<SOLRAUTH > $SECURITY_FILE
{
"authentication":{
   "blockUnknown": true,
   "class":"solr.BasicAuthPlugin",
   "credentials":{"catalog":"rJzrn+HooKn79Q+cfysdGKmMhJbtj0Q1bTokFud6f9o= eKuBUjAoBIkJAMYZxJU6HOKSchTAce+DoQrY5Vewu7I="},
   "realm":"data.gov users",
   "forwardCredentials": false
},
"authorization":{
   "class":"solr.RuleBasedAuthorizationPlugin",
   "permissions":[{"name":"security-edit",
      "role":"admin"}],
   "user-role":{"catalog":"admin"}
}}
SOLRAUTH

#  group user solr:solr is 8983:8983 in solr docker image
chown -R 8983:8983 /var/solr/data/

# Start solr
# Not sure how the path gets messed up, but it does :/ (so we have to fix it)
su -c "\
  export PATH=$PATH:/opt/docker-solr/scripts/:/opt/solr/bin/;\
  init-var-solr; precreate-core ckan /tmp/ckan_config; chown -R 8983:8983 /var/solr/data; solr-fg -Dsolr.lock.type=simple \
" -m solr
