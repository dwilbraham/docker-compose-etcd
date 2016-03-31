#!/bin/bash
set -e

if [ $# -ne 2 ]
then
  echo "Usage: $0 service_name internal_port"
  exit 1
fi

# Get port from docker-compose
address=`docker-compose port $1 $2 | cut -d: -f1`
port=`docker-compose port $1 $2 | cut -d: -f2`

if [ $address != "0.0.0.0" ]
then
  # Running with Docker Swarm address and port are correct
  echo $address:$port
else

  # Check if docker-machine is installed
  if hash docker-machine 2>/dev/null
  then
    active=`docker-machine active 2>&1 || true`
  else
    active="No active host found"
  fi

  if [ "_$active" = _"No active host found" ]
  then
    #Running locally
    echo localhost:$port
  else
    #Running with Docker Machine remotely
    echo `docker-machine ip $active`:$port
  fi

fi
