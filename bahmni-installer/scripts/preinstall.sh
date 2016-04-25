#!/bin/bash

#create bahmni user and group if doesn't exist
[ $(getent group bahmni) ]|| groupadd bahmni
[ $(getent passwd bahmni) ] || useradd -g bahmni bahmni
rm -rf /opt/bahmni-installer

rm -rf /usr/bin/bahmni
rm -rf /etc/bahmni-installer/deployment-artifacts/rpm_versions.yml
rm -rf /etc/bahmni-installer/deployment-artifacts/local
rm -rf /var/log/bahmni-installer
