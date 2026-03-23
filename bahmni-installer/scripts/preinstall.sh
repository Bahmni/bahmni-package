#!/bin/bash

#create bahmni user and group if doesn't exist
[ $(getent group bahmni) ]|| groupadd bahmni
[ $(getent passwd bahmni) ] || useradd -g bahmni bahmni
rm -rf /opt/bahmni-installer/

rm -rf /usr/bin/bahmni
rm -rf /etc/bahmni-installer/deployment-artifacts/rpm_versions.yml
rm -rf /etc/bahmni-installer/deployment-artifacts/local
rm -rf /var/log/bahmni-installer
pip install pip==v19.0
pip install --upgrade setuptools
pip install pyusb
pip install babel==v0.9.6
pip install decorator==v3.4.0
pip uninstall click
pip install click==v7.0

