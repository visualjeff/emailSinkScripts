#!/bin/bash

echo ""

if [ ! -v COUCHDB_HOST ]
then
    echo "COUCHDB_HOST variable is unset.  So I will set it..."
    COUCHDB_HOST="`hostname`.`dnsdomainname`"
fi 

echo "Starting 3 containers for the cheezyMailClient..."
sudo docker run -d -p 3990:4200 --name=adt-cheezymailclient --env HOST=$COUCHDB_HOST --env COUCHDB_PORT=3984 --env NAME=adt visualjeff/cheezymailclient:latest;
sudo docker run	-d -p 3991:4200 --name=qat-cheezymailclient --env HOST=$COUCHDB_HOST --env COUCHDB_PORT=3985 --env NAME=qat visualjeff/cheezymailclient:latest;
sudo docker run	-d -p 3992:4200 --name=spt-cheezymailclient --env HOST=$COUCHDB_HOST --env COUCHDB_PORT=3986 --env NAME=spt visualjeff/cheezymailclient:latest;

echo ""
