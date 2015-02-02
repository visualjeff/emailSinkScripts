#
container_name="adt-haraka-couchdb"
results=$(sudo docker ps | grep $container_name | awk '{print $1}')
echo $results
if [ -n "$results" ];then
	echo "SET"
fi
