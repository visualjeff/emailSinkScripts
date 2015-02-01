#!/bin/bash

echo ""
echo "Starting containers for the servers..."

source .environment_info

smtp_port=$starting_smtp_port
couchdb_port=$starting_couchdb_port
for i in "${environments[@]}"; do
    #echo "$i-haraka-couchdb" $smtp_port $couchdb_port
    sudo docker run -d -p $smtp_port:25 -p $couchdb_port:5984 --name="$i-haraka-couchdb" visualjeff/haraka-couchdb:latest;
    smtp_port=$((smtp_port + 1))
    couchdb_port=$((couchdb_port + 1))   
done
echo ""
