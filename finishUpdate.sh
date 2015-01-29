#!/bin/bash

# No longer do we delete the tar file when we're finished with it.
#if [ ! -f haraka-couchdb.tar ]; then

  COUCHDB_HOST="`hostname`.`dnsdomainname`"
  cd couchdb-dump

  cp ./backup/*.tar.gz .
  tar xvzf ./adt.tar.gz ./data;rm adt.tar.gz;./import.sh $COUCHDB_HOST 3984;rm ./data/*.json
  tar xvzf ./qat.tar.gz ./data;rm qat.tar.gz;./import.sh $COUCHDB_HOST 3985;rm ./data/*.json
  tar xvzf ./spt.tar.gz ./data;rm spt.tar.gz;./import.sh $COUCHDB_HOST 3986;rm ./data/*.json
  rm *.tar.gz
  rm -rf ./data
  cd ~

  # Add _design document (a.k.a. a view) into each database (mailbox).  Needed for combobox in client.  
  ./addDesignDocument.sh $COUCHDB_HOST 3984
  ./addDesignDocument.sh $COUCHDB_HOST 3985
  ./addDesignDocument.sh $COUCHDB_HOST 3986

  echo ""
  echo "Your update is complete!"

#fi
