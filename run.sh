#!/usr/bin/env bash

sep(){ perl -le 'print "-" x 80'; }

IMAGE=mjpg-streamer
CONTAINER=$IMAGE

docker images --format='{{.Repository}}:{{.Tag}}' | grep -q "^${IMAGE}:latest" || docker build -t $IMAGE .

docker rm -f $CONTAINER &>/dev/null
sep
echo -e "docker run --rm --detach --publish 8080:8080/tcp --device /dev/video0 \\\\"
echo -e "           --name $CONTAINER $IMAGE"
sep
docker run --rm --detach --publish 8080:8080/tcp --device /dev/video0 --name $CONTAINER $IMAGE &>/dev/null
sleep 2
docker logs -t $CONTAINER
sep
echo "curl http://test:password@localhost:8080/ -I -X GET"
sep
curl http://test:password@localhost:8080/ -I -X GET
sep



