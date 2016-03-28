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

mkdir /var/run/pacs-integration
mkdir /var/log/pacs-integration
#create links
ln -s /opt/pacs-integration/run /var/run/pacs-integration
ln -s /opt/pacs-integration/pacs-integration /var/run/pacs-integration/pacs-integration
ln -s /opt/pacs-integration/bin/pacs-integration /etc/init.d/pacs-integration
ln -s /opt/pacs-integration/etc  /etc/pacs-integration
cd /opt/pacs-integration/pacs-integration && datasetup/initDB.sh
chkconfig --add pacs-integration

#copy configs
mkdir -p /opt/pacs-integration/pacs-integration/WEB-INF/classes/ && cp /opt/pacs-integration/etc/log4j.xml /opt/pacs-integration/pacs-integration/WEB-INF/classes/

# permissions
chown -R bahmni:bahmni /opt/pacs-integration
chown -R bahmni:bahmni /var/log/pacs-integration
chown -R bahmni:bahmni /etc/init.d/pacs-integration
chown -R bahmni:bahmni /var/run/pacs-integration
