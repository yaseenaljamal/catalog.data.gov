#! /bin/bash

echo "+++ building frozen requirements +++"
for service in ckan-pip ckan-pip-tools ckan-pipenv ckan-poetry; do
  echo "*** $service ***"
  docker-compose run $service
  echo "*** end $service ***"
done

echo "+++ testing frozen requirements +++"

ls -l *.txt

for frozen in *.txt; do
  echo "*** testing $frozen ***"
  docker-compose run python pip install -r $frozen
  echo "*** end testing $frozen ***"
done



  
