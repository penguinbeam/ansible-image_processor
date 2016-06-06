#!/bin/bash
#./convert.sh
mkdir -p /home/ec2-user/temp
cd /home/ec2-user/temp
aws s3 sync --region eu-west-1 s3://opencv.penguinbeam.uk .
chmod 755 makemovie.sh 
./makemovie.sh 
aws s3 cp --region eu-west-1 --exclude “*” --include “*.mp4” /home/ec2-user/temp s3://opencv.penguinbeam.uk/