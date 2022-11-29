#!/bin/ksh
FFMPEG='ffmpeg'
CAMERA_LIST='/usr/local/webcam/cameras.txt'
DIR='/var/webcam/'
FPS=12

# Foreach line
while read line; do
	set -A arr $line
	ffmpeg -hide_banner -loglevel error -nostats -y -r $FPS -pattern_type glob -i "${DIR}${arr[0]}/img/*.jpg" -c:v libx265 -x265-params log-level=error -pix_fmt yuv420p "${DIR}${arr[0]}/timelapse.mp4"
done < "$CAMERA_LIST"

exit 0
