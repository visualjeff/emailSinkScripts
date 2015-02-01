#!/bin/bash

##START: HELPERS FUNCTIONS
function helpMsg {
	echo "** usage: ./addDesignDocument.sh DB_URL...DB_PORT..."
	echo "**  example: ./addDesignDocument.sh mycouch.adt.costco.com 5984"
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


for i in "${arr[@]}"
do
    curl -X PUT http://$url:$port/$i/_design/mailBox -d @mailBox.json

    #CAUTION: If you make a mistake and need to delete all of the mailboxes within couchdb uncomment the line below.
    #curl -X DELETE http://$url:$port/$i
done

