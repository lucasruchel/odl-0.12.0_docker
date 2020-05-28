#!/bin/bash

NUM_NODES=$1


#--------------------- config/akka.conf

config='['
for i in $(seq 1 $NUM_NODES); do 
    config=$config"\"akka.tcp:\/\/opendaylight-cluster-data@172.28.1.$i:2550\""
    if [ ! $i -eq $NUM_NODES ]; then 
        config=$config"," 
    fi 
done
config=$config']'

sed -i "s/seed-nodes.*/seed-nodes = $config/" config/akka.conf


#--------------------- config/module-shards.conf


config='['
for i in $(seq 1 $NUM_NODES); do 
    config=$config"\"member-$i\""
    if [ ! $i -eq $NUM_NODES ]; then 
        config=$config"," 
    fi 
done
config=$config']'

sed -i "s/replicas.*/replicas = $config/" config/module-shards.conf

#--------------------- docker-compose config

FILE="docker-compose.yaml"

echo "version: '3'" > $FILE

printf "\n" >> $FILE

echo "services:" >> $FILE

for i in $(seq 1 $NUM_NODES); do

printf "  odl-$i: 
    image: teste:latest\n\
    container_name: odl-$i\n\
    environment:\n\
      - CLUSTER_INDEX=$i\n\
    volumes:\n\
      - ./config:/config\n\
    networks:\n\
            odl_net:\n\
                   ipv4_address: 172.28.1.$i\n\n\
" >> $FILE

done

printf "networks:\n\
        odl_net:\n\
            ipam:\n\
                driver: default\n\
                config:\n\
                    - subnet: 172.28.0.0/16\n\
" >> $FILE
