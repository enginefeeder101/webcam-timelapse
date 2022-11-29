#!/bin/sh
WORKDIR='/var/webcam/'
TMPDIR='/tmp/'
CAMERA_LIST='/usr/local/webcam/cameras.txt'
FFMPEG='ffmpeg'
FFMPEG_FPS=12
FFMPEG_PRESET='slow'

# Do not modify
FFMPEG_COMMON='-nostdin -hide_banner -loglevel error -nostats -y'
