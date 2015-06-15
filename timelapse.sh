#!/bin/bash

#this script will create a timelapse of all the imageas from the past day (12am to 11:59pm) and then post it to a webpage

 #lets start by copying the images from the past days folder to rename them to a name that ffmpg can understand

foldername=$(date +%Y_%m_%d)
cd /var/www/openmediavault/weather/cam-archive/"$foldername"
mkdir /var/www/openmediavault/weather/timelapse/renamed-temp
counter=1
ls -1tr *.jpg | while read filename; do cp $filename renamed-temp/$(printf %05d $counter)_$filename; ((counter++)); done
cd /var/www/openmediavault/weather/timelapse/renamed-temp

#now we tell ffmpeg to do its thing

ffmpeg -f image2 -r 5 -i %*.jpg video.mp4

#now that ffmpeg has done its things we need to move the video to a file that we can access.

#rename it and move it to a new place
mv video.mp4 /var/www/openmediavault/weather/videos/$foldername.mp4
