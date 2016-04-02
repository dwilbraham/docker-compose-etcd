#!/bin/bash

docker-machine create -d virtualbox keystore
eval $(docker-machine env keystore)
etcd=`docker-machine ip keystore`:2379
docker run -d -p 2379:2379 --name keystore quay.io/coreos/etcd -name keystore -advertise-client-urls http://$etcd -listen-client-urls http://0.0.0.0:2379

docker-machine create -d virtualbox --swarm --swarm-master --swarm-discovery="etcd://$etcd" --engine-opt="cluster-store=etcd://$etcd" --engine-opt="cluster-advertise=eth1:2376" swarm0
docker-machine create -d virtualbox --swarm --swarm-discovery="etcd://$etcd" --engine-opt="cluster-store=etcd://$etcd" --engine-opt="cluster-advertise=eth1:2376" swarm1

docker-machine env --swarm swarm0
