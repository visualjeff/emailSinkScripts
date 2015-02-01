#!/bin/bash

##START: HELPERS FUNCTIONS
function helpMsg {
        echo ""
        echo "** usage:   ./update_client_only.sh IMAGE_FILE IMAGE_NAME IMAGE_VERSION"
        echo "** example: ./update_client_only.sh cheezyMailClient.tar visualjeff/cheezymailclient 1.0.0"
    echo ""
	}
## END HELPERS

##NO ARGS
if [ $# -lt 3 ]; then
        echo ":::::::::::::::::::::::::::::::::::::::::"
     echo 1>&2 "** $0: not enough arguments"
     helpMsg
     exit 2
elif [ $# -gt 3 ]; then
        echo ""
     echo 1>&2 "$0: too many arguments"
     helpMsg
fi

## VARS
image_file=$1
image_name=$2
project_name=$(echo $2 | sed 's:.*/::')
image_version=$3

source .environment_info

#echo $image_file
#echo $image_name
#echo $project_name
#echo $image_version

if [ ! -f $image_file ]; then
  echo "WARNING: Missing $image_file for loading as a new image"
else 

  echo "This may take a few minutes...  I'm loading your new image into docker"
  sudo docker load -i $image_file;
  echo "Shutting $project_name containers down..."
  sudo docker stop $(sudo docker ps | grep $project_name | awk '{print $1}');
  echo "Removing old runtime containers..."
  sudo docker rm $(sudo docker ps -a | grep "Exited" | awk '{print $1}');
  echo "Untagging $image_name:latest version..."
  sudo docker rmi -f $(echo "$image_name:latest");
  echo "Tagging a new $image_name:latest version..."
  sudo docker tag $(sudo docker images | grep $image_name | grep $image_version | awk '{print $3}') $(echo "$image_name:latest");
  ./startup_clients.sh
  
  # Need to wait here for services to start or manually perform this after they start.
  echo "Confirm the $project_name containers are running by using the command: sudo docker ps"
fi
