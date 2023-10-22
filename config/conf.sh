#!/bin/sh
WORKDIR='/data/'
TMPDIR='/tmp/'
CAMERA_LIST='/config/cameras.txt'
FFMPEG='ffmpeg'
FFMPEG_FPS=60
FFMPEG_PRESET='slow'

# Do not modify
FFMPEG_COMMON='-nostdin -hide_banner -loglevel error -nostats -y'
