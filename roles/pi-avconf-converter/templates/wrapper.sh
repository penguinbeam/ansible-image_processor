mkdir -p /home/ubuntu/temp
cd /home/ubuntu/temp
rsync pi@io:/home/pi/pi-timolo/timelapse .
#aws s3 sync --region eu-west-1 s3://{{ bucket_name }} .
cp /usr/local/bin/makemovie.sh .
find /home/ubuntu/temp/timelapse/ -size 0k -exec rm {} + && /bin/bash makemovie.sh
#aws s3 cp --region eu-west-1 --recursive --exclude "*" --include "*.mp4" /home/ec2-user/temp s3://{{ bucket_name }}/

