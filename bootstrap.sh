#!/bin/bash
#Needs role: Get_s3_bucket (My custom role to provide s3 permissions)

#To get this far you’ll have needed to do this:
# yum install -y git
# git clone https://github.com/penguinbeam/ansible-image_processor.git
# cd ansible-image_processor/

pip install ansible

echo "[somenodes]" > ~/ansible_hosts
echo "localhost ansible_connection=local" >> ~/ansible_hosts
export ANSIBLE_INVENTORY=~/ansible_hosts
/usr/local/bin/ansible all -m ping

/usr/local/bin/ansible-playbook dostuff.yml

/bin/bash /root/convert.sh


