ping -c4 io > /dev/null

if [ $? != 0 ]
then
  echo "No network connection to io"
  exit 1
fi

LockFile=/var/run/${ScriptName}.lock
if [[ -f $LockFile ]];then
        echo "Another Process was started $LockFile"
        Running=ps -ef | grep $LockFile | grep -v grep | wc -l
        if [ $Running -ne 0 ] ; then
        echo "Process still running."
        else
        echo "Stale pid file. Removing"
        rm -f $LockFile
        fi
        exit 1
fi

echo "$ProcessID" >$LockFile

mkdir -p /home/ubuntu/temp
cd /home/ubuntu/temp
rsync -vtr --remove-source-files --exclude "`ssh root@io \"ls -lrt /home/pi/pi-timolo/timelapse/*.jpg|tail -1|sed -e 's/.*\/home\/pi\/pi-timolo\///'\"`" root@io:/home/pi/pi-timolo/timelapse .
#aws s3 sync --region eu-west-1 s3://no-needed-if-no-s3 .
/bin/cp /usr/local/bin/makemovie.sh .
find /home/ubuntu/temp/timelapse/ -size 0k -exec rm {} + 
/bin/bash makemovie.sh
cp /home/ubuntu/temp/*.mp4 /home/ubuntu/movies/
#aws s3 cp --region eu-west-1 --recursive --exclude "*" --include "*.mp4" /home/ec2-user/temp s3://no-needed-if-no-s3/
cd ~
mv /home/ubuntu/temp/timelapse/*.jpg /home/ubuntu/pictures/
rm -rf /home/ubuntu/temp
rm -f $LockFile

