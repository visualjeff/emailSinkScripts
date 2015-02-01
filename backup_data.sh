#!/bin/bash

source .environment_info

cd couchdb-dump
# Loop over each environment, find the container, the port and then export
for i in "${environments[@]}"; do
    port=$(sudo docker inspect -f '{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostPort}} {{end}}' "$i-haraka-$
    port=${port/\/*/}
    ./export.sh $couchdb_host $port;tar cvzf "$i.tar.gz" ./data;rm ./data/*.json
done
echo ""
rm -rf ./data

# Move exported data to data directory
mkdir -p ./backup

# Iterate backups.  Basically keeping 3 rounds of backups.
cd ./backup
rename .tar.gz.backup4 .tar.gz.backup5 *.tar.gz.backup4
rename .tar.gz.backup3 .tar.gz.backup4 *.tar.gz.backup3
rename .tar.gz.backup2 .tar.gz.backup3 *.tar.gz.backup2
rename .tar.gz.backup1 .tar.gz.backup2 *.tar.gz.backup1
rename .tar.gz .tar.gz.backup1 *.tar.gz
cd ..
mv *.tar.gz ./backup
cd ..
