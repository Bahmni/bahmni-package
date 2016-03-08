#!/bin/bash

#create bahmni user and group if doesn't exist
[ $(getent group bahmni) ]|| groupadd bahmni
[ $(getent passwd bahmni) ] || useradd -g bahmni bahmni
rm -rf /opt/bahmni-installer/bahmni-playbooks

if [[ ! -f /opt/get-pip.py ]]; then
  echo " Downloading get-pip.py "
  curl https://bootstrap.pypa.io/get-pip.py -o "/opt/get-pip.py"
  echo "Download complete"
fi
echo " Installing pip "
python /opt/get-pip.py
pip install -U setuptools