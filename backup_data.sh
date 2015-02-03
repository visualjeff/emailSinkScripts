#!/bin/bash

##START: HELPERS FUNCTIONS
function helpMsg {
        echo "** usage: ./backup.sh <container_name>"
        echo "**  example: ./backup.sh adt-cheezymailclient"
    echo ""

        }
## END HELPERS


##NO ARGS
if [ $# -gt 1 ]; then
     echo ""
     echo 1>&2 "$0: too many arguments"
     helpMsg
fi

source .environment_info

## VARS
container_name=$1

cd couchdb-dump
mkdir -p ./backup

if [ -n "$container_name" ]; then
  #backup one container
  containerid=$(sudo docker ps | grep $container_name | awk '{print $1}')
  if [ -n "$containerid" ];then
    port=$(sudo docker inspect -f '{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostPort}} {{end}}' $container_name)
    port=$(echo $port | grep -Po ' 5984/tcp -> \K.*')
    port=$(expr substr $port 1 4)
    echo "  Exporting data from environment $container_name on $couchdb_host:$port"
    ./export.sh $couchdb_host $port
    i=$(echo $container_name | cut -f1 -d"-")
      cd backup
      # Didn't use rename for backup file renames because it depends on an external perl app.
      file="$i.tar.gz.backup4"
      if [ -f "$file" ]; then
        mv $file "${file%.tar.gz.backup4}.tar.gz.backup5"
      fi
      file="$i.tar.gz.backup3"
      if [ -f "$file" ]; then
        mv $file "${file%.tar.gz.backup3}.tar.gz.backup4"
      fi
      file="$i.tar.gz.backup2"
      if [ -f "$file" ]; then
        mv $file "${file%.tar.gz.backup2}.tar.gz.backup3"
      fi
      file="$i.tar.gz.backup1"
      if [ -f "$file" ]; then
	  mv $file "${file%.tar.gz}.tar.gz.backup1"
      fi
      file="$i.tar.gz"
      if [ -f "$file" ]; then
          mv $file "${file%.tar.gz}.tar.gz.backup1"
      fi
      cd ..
    tar czf "./backup/$i.tar.gz" data/
    echo "  Backup complete $i-haraka-couchdb"
  fi 
else
  # Backup all of them
  # Loop over each environment, find the container, the port and then export
  for i in "${environments[@]}"; do
    port=$(sudo docker inspect -f '{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostPort}} {{end}}' "$i-haraka-couchdb")
    if [ ! -z "$port" -a "$port" != "" ]; then
    port=$(echo $port | grep -Po ' 5984/tcp -> \K.*')
    port=$(expr substr $port 1 4)

    echo "  Exporting data from environment $i-haraka-couchdb on $couchdb_host:$port"
    ./export.sh $couchdb_host $port

    # Iterate backups.  Basically keeping 5 rounds of backups.
    cd backup

    #Didn't use rename for backup file renames because it depends on an external perl app.
    file="$i.tar.gz.backup4"
    if [ -f "$file" ]; then
        mv $file "${file%.tar.gz.backup4}.tar.gz.backup5"
      fi
    file="$i.tar.gz.backup3"
       if [ -f "$file" ]; then
         mv $file "${file%.tar.gz.backup3}.tar.gz.backup4"
       fi
    file="$i.tar.gz.backup2"
       if [ -f "$file" ]; then
         mv $file "${file%.tar.gz.backup2}.tar.gz.backup3"
       fi
    file="$i.tar.gz.backup1"
       if [ -f "$file" ]; then
         mv $file "${file%.tar.gz.backup1}.tar.gz.backup2"
       fi
    file="$i.tar.gz"
     if [ -f "$file" ]; then
       mv $file "${file%.tar.gz}.tar.gz.backup1"
     fi
    cd ..
    tar czf "./backup/$i.tar.gz" data/
    echo "  Backup complete $i-haraka-couchdb"
  fi
  done
fi

echo ""
if [ -d "./data" ]; then
  rm -rf ./data
fi

cd ..
