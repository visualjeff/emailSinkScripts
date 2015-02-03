#!/bin/bash

##START: HELPERS FUNCTIONS
function helpMsg {
        echo ""
        echo "** usage:   ./shutdown_servers.sh <container_name>"
        echo "** example: ./shutdown_servers.sh haraka-couchdb"
        echo "** example: ./shutdown_servers.sh adt-haraka-couchdb"
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

echo "Performing a backup..."

if [ -n "$1" ]; then
  #variable set
  container_name=$(echo $1 | sed 's:.*/::')
  
else 
  #variable not set
  container_name="haraka-couchdb"
fi

echo "The container name you entered is: $container_name"

arr=($(sudo docker ps | grep $container_name | awk '{print $12}'))

for i in "${arr[@]}"
do
  echo "  Attempting to backup $i"
  ./backup_data.sh $i
done

echo "Shutting $project_name containers down..."
sudo docker stop $(sudo docker ps | grep $container_name | awk '{print $1}');
echo "Removing old runtime containers..."
sudo docker rm $(sudo docker ps -a | grep "Exited" | awk '{print $1}');
