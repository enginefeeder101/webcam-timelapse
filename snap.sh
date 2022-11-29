#!/bin/ksh
FFMPEG='ffmpeg'
CAMERA_LIST='/usr/local/webcam/cameras.txt'
DIR='/var/webcam/'
QUALITY=25

# Get current date and time
DATETIME=$(date '+%Y-%m-%d_%H-%M')

# Foreach line
while read line; do
	set -A arr $line
	CAMDIR="${DIR}${arr[0]}/img/"
	mkdir -m 700 -p "${CAMDIR}"
	ffmpeg -hide_banner -loglevel error -nostats -y -i "${arr[1]}" -f image2 -q:v $QUALITY -vframes 1 "${CAMDIR}${DATETIME}.jpg" &
done < "$CAMERA_LIST"

exit 0
