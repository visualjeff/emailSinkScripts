#!/bin/bash

##START: HELPERS FUNCTIONS
function helpMsg {
        echo "** usage: ./import.sh DB_URL...DB_PORT..."
        echo "**  example: ./import.sh mycouch.adt.costco.com 3894"
    echo ""

        }
## END HELPERS


##NO ARGS
if [ $# -lt 2 ]; then
        echo ":::::::::::::::::::::::::::::::::::::::::"
     echo 1>&2 "** $0: not enough arguments"
     helpMsg
     exit 2
elif [ $# -gt 2 ]; then
        echo ""
     echo 1>&2 "$0: too many arguments"
     helpMsg
fi


## VARS
url=$1
port=$2

fullUrl="$1:$2"
echo "Importing into: $fullUrl"
echo ""
FILES=./data/*

for fileName in $FILES
do
	echo "importing $fileName"
	databaseName=( $(echo $fileName | sed "s/\.json//"))

#echo "  DATABASE_NAME=$databaseName"
#echo "  FILE_NAME=$fileName"

	./bin/couchdb-restore.sh $fullUrl $databaseName $fileName
done
echo ""
echo "Data imported.  Please confirm.  Then remove the data directory that contains your records."
