#!/bin/bash

##START: HELPERS FUNCTIONS
function helpMsg {
        echo ""
        echo "** usage:   ./shutdown_servers.sh <container_name>"
        echo "** example: ./shutdown_servers.sh haraka-couchdb"
    echo ""
        }
## END HELPERS

##NO ARGS
if [ $# -lt 1 ]; then
        echo ":::::::::::::::::::::::::::::::::::::::::"
     echo 1>&2 "** $0: not enough arguments"
     helpMsg
     exit 2
elif [ $# -gt 1 ]; then
        echo ""
     echo 1>&2 "$0: too many arguments"
     helpMsg
fi

## VARS
container_name=$(echo $1 | sed 's:.*/::')

echo "Performing a backup..."
./backup_data.sh  

echo "Shutting $project_name containers down..."
sudo docker stop $(sudo docker ps | grep $container_name | awk '{print $1}');
echo "Removing old runtime containers..."
sudo docker rm $(sudo docker ps -a | grep "Exited" | awk '{print $1}');
