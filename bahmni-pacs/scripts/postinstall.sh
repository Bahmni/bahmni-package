#!/bin/bash

#create bahmni user and group if doesn't exist
USERID=bahmni
GROUPID=bahmni
/bin/id -g $GROUPID 2>/dev/null
[ $? -eq 1 ]
groupadd bahmni

/bin/id $USERID 2>/dev/null
[ $? -eq 1 ]
useradd -g bahmni bahmni

mkdir /var/run/bahmni-pacs
mkdir /var/log/bahmni-pacs
#create links
ln -s /opt/bahmni-pacs/run /var/run/bahmni-pacs
ln -s /opt/bahmni-pacs/pacs-integration /var/run/bahmni-pacs/pacs-integration
ln -s /opt/bahmni-pacs/bin/bahmni-pacs /etc/init.d/bahmni-pacs
cd /opt/bahmni-pacs/pacs-integration && datasetup/initDB.sh
chkconfig --add bahmni-pacs

#copy configs
mkdir -p /opt/bahmni-pacs/pacs-integration/WEB-INF/classes/ && cp /opt/bahmni-pacs/etc/log4j.xml /opt/bahmni-pacs/pacs-integration/WEB-INF/classes/

# permissions
chown -R bahmni:bahmni /opt/bahmni-pacs
chown -R bahmni:bahmni /var/log/bahmni-pacs
chown -R bahmni:bahmni /etc/init.d/bahmni-pacs
chown -R bahmni:bahmni /var/run/bahmni-pacs
