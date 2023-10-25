#!/bin/ksh

. /config/conf.sh

# Get current date and time
DATETIME=$(date '+%Y-%m-%d_%H-%M')

# Foreach webcam entry
while read line; do
	set -A wcparam $line

	# $wcparam[0] = camera name
	# $wcparam[1] = JPEG quality
	# $wcparam[2] = ffmpeg -crf value of the timelapse video
	# $wcparam[3] = RTSP stream URI

	CAMDIR="${WORKDIR}${wcparam[0]}/"
	IMGDIR="${CAMDIR}img/"
	IMG="${IMGDIR}${DATETIME}.jpg"
	mkdir -m 700 -p "$IMGDIR"
	if [ "${wcparam[1]}" = "99" ]; then
		curl -s "${wcparam[3]}" -o "$IMG"
	else
		"$FFMPEG" $FFMPEG_COMMON -skip_frame nokey -i "${wcparam[3]}" -vsync vfr -f image2 -q:v ${wcparam[1]} -frames:v 1 "$IMG" &
	fi
	echo "file '$IMG'" >> "${CAMDIR}/unprocessed.txt"
done < "$CAMERA_LIST"

exit 0
