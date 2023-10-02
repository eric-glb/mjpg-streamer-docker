#!/usr/bin/env bash

sep(){
  read -r LINES COLUMNS < <(stty size 2>/dev/null)
  perl -le 'print "─" x $ARGV[0]' "${COLUMNS:-80}"
}


IMAGE=mjpg-streamer
CONTAINER=$IMAGE

sep
echo "docker rm -f $CONTAINER &>/dev/null"
docker rm -f $CONTAINER &>/dev/null
sep



