#!/bin/bash

  source .environment_info

  cd couchdb-dump
  cp ./backup/*.tar.gz .
  # Loop over each environment, find the container, the port and then export
  for i in "${environments[@]}"; do
      port=$(sudo docker inspect -f '{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostPort}} {{end}}' "$i-haraka-$
      port=${port/\/*/}
      tar xvzf ./"$i.tar.gz" ./data;rm "$i.tar.gz";./import.sh $couchdb_host $port;rm ./data/*.json 
      ~./addDesignDocument.sh $couchdb_host $port
  done
  echo ""
  rm *.tar.gz
  rm -rf ./data
  cd ~
