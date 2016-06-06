#!/bin/bash
#Needs role: Get_s3_bucket (s3 permissions)

pip install ansible

echo "[somenodes]" > ~/ansible_hosts
echo "localhost ansible_connection=local" >> ~/ansible_hosts
export ANSIBLE_INVENTORY=~/ansible_hosts
/usr/local/bin/ansible all -m ping

/usr/local/bin/ansible-playbook dostuff.yml

/bin/bash /root/convert.sh


