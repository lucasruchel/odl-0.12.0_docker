#!/bin/bash

cd $(dirname $0)

docker-compose up -d

NUM_ODL=$1

sleep 150

# Remove kesys from knows_hosts
echo '' >  ~/.ssh/known_hosts

for i in $(seq 1 $NUM_ODL); do 
	docker exec -it odl-$i bin/client log:set DEBUG
done
