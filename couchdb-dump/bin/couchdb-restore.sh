#!/bin/bash

## this script restore a couchdb database-file to a couchdb database instance
## FILE should be:
##  1. result of a couchdb-dump.sh command
##  2. OR formatted as explained @ http://wiki.apache.org/couchdb/HTTP_Bulk_Document_API


## USAGE
## ** example: bash couchdb-restore mycouch.com my-db dumpedDB.txt**
# syntax: bash couchdb-dump URL... DB_NAME... DUMPED_DB_FILENAME...
## DB_URL: the url of the couchdb instance without 'http://', e.g. mycouch.com
## DB_NAME: name of the database, e.g. 'my-db
## DUMPED_DB_FILENAME... : file containing the JSON object with all the docs

###################### CODE STARTS HERE ###################

##START: HELPERS FUNCTIONS
function helpMsg {
	echo "** usage: ./couchdb-restore DB_URL... DB_NAME... DUMPED_DB_FILENAME..."
	echo "**  example: ./couchdb-restore.sh mycouch.com my-db dumpedDB.txt"
    echo "**  DB_URL: the url of the couchdb instance without 'http://', e.g. mycouch.com"
    echo "**  DB_NAME: name of the database, e.g. 'my-db'"
    echo "**  DUMPED_DB_FILENAME... : file containing the JSON object with all the docs, e.g. dumpedDB.txt"

	}


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
url=$1
db_name=( $(echo $2 | sed "s/\.\/data\///"))
file_name=$3

#echo "  $url"
#echo "  $db_name"
#echo "  $file_name"

curl -X PUT http://$url/$db_name

# Customization by jgilber
# To success restore our exported docs by bulk we need to add the new_edits property and set it false before uploading.
sed '0,/{/s//{\n"new_edits":false,\n/' -i $file_name

curl --data-binary @$file_name -X POST http://$url/$db_name/_bulk_docs -H 'Content-Type: application/json'
