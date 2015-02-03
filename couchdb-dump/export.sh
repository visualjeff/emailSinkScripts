#!/bin/bash


##START: HELPERS FUNCTIONS
function helpMsg {
	echo "** usage: ./export.sh DB_URL...DB_PORT..."
	echo "**  example: ./export.sh mycouch.adt.costco.com 3894"
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

arr=( $(echo "`curl -sX GET http://$url:$port/_all_dbs 2>&1`" | grep -Po 'mail_[^ ]*' | sed "s/\"//g" | sed "s/,/ /g" | sed "s/]//") )
#echo ${arr[*]}

fullUrl="$url:$port"
#echo "  Exporting from: $fullUrl"

mkdir -p ./data

for i in "${arr[@]}"
do
   outputFile="$i.json"
   ./bin/couchdb-dump.sh $fullUrl $i > ./data/$outputFile
done

