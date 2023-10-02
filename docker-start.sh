#!/bin/sh

mjpg_streamer -o "output_http.so -w /usr/local/share/mjpg-streamer/simple -c ${USER:=test}:${PASSWD:=password}" \
              -i "input_uvc.so -d /dev/video0 -r 1280x720 -l off -n"

