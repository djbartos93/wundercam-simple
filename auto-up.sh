#!/bin/bash
#this part gets the image

wget http://172.16.0.30/goform/capture?1072918905414781

mv capture?1072918905414781 imageraw.jpg #renames to something uesful

#now we add the time!

TIMESTAMP=$(date)

convert "imageraw.jpg" -font Courier -pointsize 18  -fill white -undercolor '#00000080'  -gravity NorthWest -annotate +0+5 "`date`" image.jpg
# -pointsize 20 -fill white -background black -draw 't "$TIMESTAMP" ' image.jpg image.jpg

#before we FTP the file it needs archiving...
#we need a folder each day for this to be organized
#this will create a folder if it doesnt exist with the date
foldername=$(date +%Y_%m_%d)
mkdir -p /var/www/openmediavault/weather/cam-archive/"$foldername"
#This part moves the file to the webpage/archive

now=$(date +"%m_%d_%y-%T")

cp -v image.jpg /var/www/openmediavault/weather/cam-archive/"$foldername"/image-$now.jpg

cp -v image.jpg /var/www/openmediavault/weather/current.jpg

#here is the part that uploads stuff


HOST=webcam.wunderground.com  #This is the FTP servers host or IP address.
USER=*wunderground username*             #This is the FTP user that has access to the server.
PASS=*wunderground password*         #This is the password for the FTP user.

ftp -inv $HOST <<-EOF
user $USER $PASS
cd /
put image.jpg

# Call 1. Uses the ftp command with the -inv switches.  -i turns off interactive     prompting. -n Restrains FTP from attempting the auto-login feature. -v enables verbose and progress.

#ftp -inv $HOST <<-EOF

# Call 2. Here the login credentials are supplied by calling the variables.

#user $USER $PASS

# Call 3. Here you will change to the directory where you want to put or get
#cd /

# Call4.  Here you will tell FTP to put or get the file.
#put image1.jpeg

# End FTP Connection
bye
EOF
