#!/bin/bash

echo ""
echo "Starting 3 containers for haraka-couchdb..."

sudo docker run -d -p 3025:25 -p 3984:5984 --name=adt-haraka-couchdb visualjeff/haraka-couchdb:latest;
sudo docker run -d -p 3026:25 -p 3985:5984 --name=qat-haraka-couchdb visualjeff/haraka-couchdb:latest;
sudo docker run -d -p 3027:25 -p 3986:5984 --name=spt-haraka-couchdb visualjeff/haraka-couchdb:latest;

echo ""
