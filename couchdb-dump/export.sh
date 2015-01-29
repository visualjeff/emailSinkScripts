#!/bin/bash


###################### CODE STARTS HERE ###################

##START: HELPERS FUNCTIONS
function helpMsg {
	echo "** usage: bash export.sh DB_URL...DB_PORT..."
	echo "**  example: bash couchdb-dump.sh mycouch.adt.costco.com 3059"
    echo "**  DB_URL: the url of the couchdb instance without 'http://', e.g. mycouch.com"
    echo "**  DB_PORT: port used by the database, e.g. '5984'"
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
echo "exporting from: $fullUrl"

mkdir -p ./data

for i in "${arr[@]}"
do
   outputFile="$i.json"
   ./bin/couchdb-dump.sh $fullUrl $i > ./data/$outputFile
done

