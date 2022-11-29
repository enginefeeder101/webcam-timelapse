# cesium webcam timelapse
Shell script based routine that takes snapshots from IP webcams and periodically creates timelapse video using ffmpeg.

## Prerequisities
Korn shell `ksh` (OpenBSD's default shell)

## Installation
### System user

	useradd -c "Webcam routine" -b /var/webcam/ -d /var/webcam/ -s /sbin/nologin _webcam
	install -d -m 770 -o root -g _webcam /var/webcam/

### Clone & file copy

	cd /tmp/
	git clone <REPO_URL>
	install -d -m 755 -o root -g _webcam /usr/local/webcam/
	install -m 754 -o root -g _webcam snap.sh /usr/local/webcam/
	install -m 754 -o root -g _webcam render.sh /usr/local/webcam/
	rm -rf /tmp/webcam_timelapse/

### Configuration
#### Camera list

	vim /usr/local/webcam/cameras.txt

For each webcam, insert the following line:

	cam_name rtsp://...

Set ownership

	chown -R root:_webcam /usr/local/webcam/
	chmod 660 /usr/local/webcam/cameras.txt

### Directory structure
	/var/webcam/
	|-- cam1
	|   |-- img
	|   |   |-- 2022-08-24_10-00.jpg
	|   |   `-- 2022-08-24_11-00.jpg
	|   `-- timelapse.mp4
	`-- cam2
	    |-- img
	    |   |-- 2022-08-24_10-00.jpg
	    |   `-- 2022-08-24_11-00.jpg
	    `-- timelapse.mp4

#### Image quality
Quality of each JPEG snapshot can be set in `snap.sh` in order to reduce storage requirements.  
Normal range for JPEG is 2-31 with 31 being the worst quality.

### Cron
Grab a snapshot every hour, render video once a day. In this manner, one day equals 1 second in final 24 FPS timelapse video.

	crontab -e -u _webcam
	0 * * * * /usr/local/webcam/snap.sh
	0 3 * * * /usr/local/webcam/render.sh

## Testing

	su -l _webcam /usr/local/webcam/snap.sh
	su -l _webcam /usr/local/webcam/render.sh

Or alternative using `doas` command:

	doas -u _webcam /usr/local/webcam/snap.sh

## Author
[Matyáš Vohralík](https://mv.cesium.cz) 2022

## License
[BSD 3-Clause](LICENSE)