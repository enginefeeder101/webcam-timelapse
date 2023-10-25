# webcam-timelapse
Docker image that takes snapshots from IP webcams and periodically creates a timelapse video using FFmpeg.

## Installation

	git clone https://github.com/enginefeeder101/webcam-timelapse.git
	cd webcam-timelapse
	docker compose up

### Configuration
#### Paths
Set your environment-specific paths and ffmpeg parameters in `conf.sh`

	vim config/conf.sh

#### Camera list

	vim config/cameras.txt

For each webcam, insert a line according to the following syntax:

	cam_name jpg_quality ffmpeg_crf rtsp_uri

- *cam_name* = unique string camera name. Use short and simple names.
- *jpg_quality* = JPEG snapshot quality. The normal range for JPEG is 2-31 with 31 being the worst quality. Can be used to optimize storage footprint. Use 99 to for a JPEG screen grab.
  **Once a snapshot is taken, its quality cannot be increased.**
- *ffmpeg_crf* = Use Constant Rate Factor (CRF) to control the quality of the timelapse video. The default is 28. See [H.265 documentation](https://trac.ffmpeg.org/wiki/Encode/H.265).
- *rtsp_uri* = RTSP stream URI

Example contents of `cameras.txt`

	entrance 20 28 rtsp://192.168.1.100/user=monitor_password=pdTzQLK6Iq_channel=1_stream=0.sdp
	backyard 25 40 rtsp://192.168.1.101/user=monitor_password=6oLA64UG_channel=1_stream=0.sdp
	sidedoor 99 00 http://192.168.1.102/ISAPI/Streaming/channels/101/picture?snapShotImageType=JPEG

Set proper permissions (`cameras.txt` is likely to contain credentials)

	chown user:group config/cameras.txt
	chmod 660 config/cameras.txt

### Cron
Grab a snapshot every hour, and render video once a day. In this manner, one day equals 1 second in the final 24 FPS timelapse video.  
**NOTICE: Prevent render to execute at the same time as snap and set sufficient delay as follows.**

	vim config/schedule
	
	0 * * * * snap.sh
	5 3 * * * render.sh

### PUID & PGID
Docker runs all of its containers under the root user. This means that the processes running inside the container also run as root.
This causes issue in file management within the container's mapped volumes. If the process is running under root, all files and directories created  will be owned by root, thus becoming inaccessible by you. Using the PUID and PGID allows the container to map the container's internal user to a user on the host machine.

	vim docker-compose.yaml

	environment:
	- PUID=1000
	- PGID=1000

## Changing timelapse video parameters
Since `render.sh` appends a new video segment at the end of the timelapse without reencoding it completely, any change of output timelapse video parameters (FPS, CRF, Preset) must be followed by a complete reencode.  
**WARNING: This operation may be very source consumptive and can take a long time.**  
Users are discouraged to execute a such operation on a production machine. Use a dedicated machine instead.

	tar -czf /tmp/webc_backup.tar.gz /var/webcam/cam1/img/

Transfer the archive to dedicated machine and reencode the video

	ffmpeg -pattern_type glob -i "cam1/img/*.jpg" -r <FFMPEG_FPS> -c:v libx265 -crf <CRF> -preset <PRESET> -pix_fmt yuv420p cam1/timelapse.mp4

...and place the video back on the server

## Testing

	docker compose exec --user 1000 webcam-timelapse snap.sh
	docker compose exec --user 1000 webcam-timelapse render.sh

## Modus operandi
**`snap.sh`** does the following sequentially for each webcam:
- takes a JPEG snapshot of specified quality,
- saves the output image in webcam specific directory with a filename containing the date and time of the snapshot,
- appends the filename to the list of unprocessed files `unprocessed.txt`

**`render.sh`** does the following sequentially for each webcam:
- creates a temporary copy of `unprocessed.txt` list of images that are to be encoded and clears the original list,
- renders a short video to the temporary directory from images in `unprocessed.txt` list,
- appends the short video at the end of the existing timelapse without reencoding the whole video using ffmpeg's demuxer

*A temporary video is necessary because ffmpeg cannot append images directly to the existing video, it supports video concatenation instead.*

### Directory structure
	/data/
	|-- cam1
	|   |-- img
	|   |   |-- 2022-08-24_10-00.jpg
	|   |   `-- 2022-08-24_11-00.jpg
	|   |-- timelapse.mp4
	|   `-- unprocessed.txt
	`-- cam2
	    |-- img
	    |   |-- 2022-08-24_10-00.jpg
	    |   `-- 2022-08-24_11-00.jpg
	    |-- timelapse.mp4
	    `-- unprocessed.txt

## Author
[Engine Feeder](https://github.com/enginefeeder101/webcam-timelapse), 2023
[Matyáš Vohralík](https://mv.cesium.cz), 2022

## License
[BSD 3-Clause](LICENSE)
