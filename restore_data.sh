#!/bin/bash

source .environment_info

cd couchdb-dump
cp ./backup/*.tar.gz .
# Loop over each environment, find the container, the port and then export
for i in "${environments[@]}"; do
    port=$(sudo docker inspect -f '{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostPort}} {{end}}' "$i-haraka-couchdb")
    port=$(echo $port | grep -Po ' 5984/tcp -> \K.*')
    port=$(expr substr $port 1 4)
    tar xvzf ./"$i.tar.gz" ./data;rm "$i.tar.gz";./import.sh $couchdb_host $port;rm ./data/*.json 
    # If the view mailbox is imported then you don't need to run the code below.
    #cd ..
    #./addDesignDocument.sh $couchdb_host $port
    #cd couchdb-dump
done
echo ""

# Clean up
rm *.tar.gz
rm -rf data
cd ~
