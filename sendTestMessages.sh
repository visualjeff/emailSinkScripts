#!/bin/bash

source .environment_info

smtp_port=$starting_smtp_port

for i in "${environments[@]}"; do
  container_name="$i-haraka-couchdb"
  containerid=$(sudo docker ps | grep $container_name | awk '{print $1}')
  if [ -z "${containerid}" ]; then
    #container doesn't exist so skip the test.
    echo "  skipping..."
  else
    echo "  sending test message to $container_name"
    swaks --to systemTest@costco.com -s 0.0.0.0 -p $smtp_port 
  fi  
  smtp_port=$((smtp_port + 1))
done
