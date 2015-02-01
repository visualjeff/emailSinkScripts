#!/bin/bash

echo ""

echo "Starting 3 containers for the cheezyMailClient..."

source .environment_info

cheezy_port=$starting_cheezy_port
couchdb_port=$starting_couchdb_port
for i in "${environments[@]}"; do
    sudo docker run -d -p $cheezy_port:4200 --name="$i-cheezymailclient" --env HOST=$couchdb_host --env COUCHDB_PORT=$couchdb_port --env NAME=$i visualjeff/cheezymailclient:latest;
    cheezy_port=$((cheezy_port + 1))
    couchdb_port=$((couchdb_port + 1))
done

echo ""
