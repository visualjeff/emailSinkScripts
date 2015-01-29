#!/bin/bash

COUCHDB_HOST="`hostname`.`dnsdomainname`"

cd couchdb-dump

./export.sh $COUCHDB_HOST 3984;tar cvzf adt.tar.gz ./data;rm ./data/*.json
./export.sh $COUCHDB_HOST 3985;tar cvzf qat.tar.gz ./data;rm ./data/*.json
./export.sh $COUCHDB_HOST 3986;tar cvzf spt.tar.gz ./data;rm ./data/*.json
rm -rf ./data

#move exported data to data directory
mkdir -p ./backup

#iterate backups.  Basically keeping 3 rounds of backups.
cd ./backup
rename .tar.gz.backup2 .tar.gz.backup3 *.tar.gz.backup2
rename .tar.gz.backup1 .tar.gz.backup2 *.tar.gz.backup1
rename .tar.gz .tar.gz.backup1 *.tar.gz
cd ..
mv *.tar.gz ./backup
cd ..
