#!/bin/bash
#Needs role: Get_s3_bucket (s3 permissions)

pip install ansible

echo "[somenodes]" > ~/ansible_hosts
echo "localhost ansible_connection=local" >> ~/ansible_hosts
export ANSIBLE_INVENTORY=~/ansible_hosts
/usr/local/bin/ansible all -m ping


cat > /tmp/build.sh << EOF
#!/bin/bash
cd /root
tar -xvzf libav-10.1.tar.gz
cd libav-10.1
./configure --extra-cflags=-I/opt/local/include --extra-ldflags=-L/opt/local/lib --enable-gpl --enable-version3  --enable-libvpx
make
make install
ln -s /usr/local/bin/avconv /usr/bin/avconv 
EOF

cat > /tmp/convert.sh << EOF
#!/bin/bash
mkdir -p /home/ec2-user/temp
cd /home/ec2-user/temp
aws s3 sync --region eu-west-1 s3://opencv.penguinbeam.uk .
chmod 755 makemovie.sh 
./makemovie.sh 
aws s3 cp --region eu-west-1 --exclude “*” --include “*.mp4” /home/ec2-user/temp s3://opencv.penguinbeam.uk/
EOF

cat > /root/dostuff.yml << EOF
---
- hosts: somenodes
  remote_user: root

  tasks:
  - name: Install vim
    yum: name=vim state=latest

  - name: Install all the needed bits
    yum: pkg=libvorbis,yasm,freetype,zlib,bzip2,speex,libvpx,libogg,gcc,libvpx-devel state=latest

  - name: write the script to build from source
    template: src=/tmp/build.sh dest=/root/build.sh

  - name: write the script to process images from s3
    template: src=/tmp/convert.sh dest=/root/convert.sh

  - name: download av software
    get_url: url=http://libav.org/releases/libav-10.1.tar.gz dest=/root/libav-10.1.tar.gz mode=0440 force=no
    notify:
    - run build script

  - name: write the script to build from source
    template: src=/tmp/build.sh dest=/root/script.sh
    notify:
    - run build script

  handlers:
  - name : run build script
    script: /root/script.sh -
EOF

/usr/local/bin/ansible-playbook /root/dostuff.yml
/bin/bash /root/convert.sh


