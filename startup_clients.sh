#!/bin/bash

echo ""

echo "Starting containers for the client..."

source .environment_info

cheezy_port=$starting_cheezy_port
couchdb_port=$starting_couchdb_port
for i in "${environments[@]}"; do
    container_name="$i-cheezymailclient"
    containerid=$(sudo docker ps | grep $container_name | awk '{print $1}')
    if [ -z "${containerid}" ];then
        # Container doesn't exit so create it 
        echo "  starting $container_name"
        sudo docker run -d -p $cheezy_port:4200 --name=$container_name --env HOST=$couchdb_host --env COUCHDB_PORT=$couchdb_port --env NAME=$i visualjeff/cheezymailclient:latest;
    else 
       echo "  $container_name is already running"
    fi
    cheezy_port=$((cheezy_port + 1))
    couchdb_port=$((couchdb_port + 1))
done

echo ""
