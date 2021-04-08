#!/bin/bash

if [ -f /etc/bahmni-installer/bahmni.conf ]; then
. /etc/bahmni-installer/bahmni.conf
fi

#create bahmni user and group if doesn't exist
USERID=bahmni
GROUPID=bahmni
/bin/id -g $GROUPID 2>/dev/null
[ $? -eq 1 ]
groupadd bahmni

/bin/id $USERID 2>/dev/null
[ $? -eq 1 ]
useradd -g bahmni bahmni

mkdir /var/log/pacs-integration
#create links
ln -s /opt/pacs-integration/etc  /etc/pacs-integration
#create a database if it doesn't exist and if it is not passive machine.
if [ "${IS_PASSIVE:-0}" -ne "1" ]; then
    cd /opt/pacs-integration/pacs-integration && datasetup/initDB.sh
fi
chkconfig --add pacs-integration

# permissions
chown -R bahmni:bahmni /opt/pacs-integration
chown -R bahmni:bahmni /var/log/pacs-integration

