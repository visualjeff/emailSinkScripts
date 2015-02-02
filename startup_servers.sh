#!/bin/bash

echo ""
echo "Starting containers for the servers..."

source .environment_info

smtp_port=$starting_smtp_port
couchdb_port=$starting_couchdb_port
for i in "${environments[@]}"; do
    container_name="$i-haraka-couchdb"
    containerid=$(sudo docker ps | grep $container_name | awk '{print $1}')
    if [ -z "${containerid}" ];then
       # Container doesn't exit so create it
       echo "  starting $container_name" 
       sudo docker run -d -p $smtp_port:25 -p $couchdb_port:5984 --name=$container_name visualjeff/haraka-couchdb:latest;
    else
       echo "  $container_name is already running"
    fi
    smtp_port=$((smtp_port + 1))
    couchdb_port=$((couchdb_port + 1))
done
echo ""
