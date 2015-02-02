#!/bin/bash

source .environment_info

cd couchdb-dump
# Loop over each environment, find the container, the port and then export
for i in "${environments[@]}"; do
    port=$(sudo docker inspect -f '{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostPort}} {{end}}' "$i-haraka-couchdb")
    port=$(echo $port | grep -Po ' 5984/tcp -> \K.*')
    port=$(expr substr $port 1 4)
    echo "Exporting data from environment $i-haraka-couchdb on $couchdb_host:$port"
    ./export.sh $couchdb_host $port;tar cvzf "$i.tar.gz" ./data
done
echo ""
if [ -d "./data" ]; then
  rm -rf ./data
fi


# Move exported data to data directory
mkdir -p ./backup

# Iterate backups.  Basically keeping 3 rounds of backups.
cd backup
# Didn't use rename for backup file renames because it depends on an external perl app.
for file in *.backup4
do
  if [ $file != "*.backup4" ]; then
    mv "$file" "${file%.tar.gz.backup4}.tar.gz.backup5"
  fi
done
for file in *.backup3
do
  if [ $file != "*.backup3" ]; then
    mv "$file" "${file%.tar.gz.backup3}.tar.gz.backup4"
  fi
done
for file in *.backup2
do
  if [ $file != "*.backup2" ]; then
    mv "$file" "${file%.tar.gz.backup2}.tar.gz.backup3"
  fi
done
for file in *.backup1
do
  if [ $file != "*.backup1" ]; then
    mv "$file" "${file%.tar.gz.backup1}.tar.gz.backup2"
  fi
done
for file in *.tar.gz
do
  if [ $file != "*.tar.gz" ]; then
    mv "$file" "${file%.tar.gz}.tar.gz.backup1"
  fi
done

cd ..
mv *.tar.gz ./backup
cd ..
