#!/usr/bin/env bash

sep(){
  read -r LINES COLUMNS < <(stty size 2>/dev/null)
  perl -le 'print "─" x $ARGV[0]' "${COLUMNS:-80}"
}

IMAGE=mjpg-streamer
CONTAINER=$IMAGE

USER=${1:-test}
PASSWD=${2:-password}
HOSTNAME=$(hostname -A | awk '{print $1}')

sep
echo "docker images --format='{{.Repository}}:{{.Tag}}' | grep -q \"^${IMAGE}:latest\" || docker build -t $IMAGE ."
docker images --format='{{.Repository}}:{{.Tag}}' | grep -q "^${IMAGE}:latest" || docker build -t $IMAGE .

sep
echo "docker rm -f $CONTAINER &>/dev/null"
docker rm -f $CONTAINER &>/dev/null

sep
cat <<EOF
docker run --rm \\
           --env USER="$USER" \\
           --env PASSWD="$PASSWD" \\
           --detach \\
           --publish 8080:8080/tcp \\
           --device /dev/video0 \\
           --name $CONTAINER \\
           $IMAGE &>/dev/null
EOF

sep
docker run --rm \
           --env USER="$USER" \
           --env PASSWD="$PASSWD" \
           --detach \
           --publish 8080:8080/tcp \
           --device /dev/video0 \
           --name $CONTAINER \
           $IMAGE &>/dev/null
sleep 2
docker logs -t $CONTAINER

sep
for host in localhost "${HOSTNAME}"; do
  printf "%-66s %s" "curl http://${USER}:${PASSWD}@${host}:8080/ -I -X GET" "-> "
  curl -s http://${USER}:${PASSWD}@${host}:8080/ -I -X GET | head -1
done
sep



