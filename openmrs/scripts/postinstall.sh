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

#create links
ln -s /opt/openmrs/etc /etc/openmrs
ln -s /opt/openmrs/bin/openmrs /etc/init.d/openmrs
ln -s /opt/openmrs/run /var/run/openmrs
ln -s /opt/openmrs/openmrs /var/run/openmrs/openmrs
ln -s /opt/openmrs/log /var/log/openmrs

(cd /opt/openmrs/openmrs && unzip ../openmrs.war)

chkconfig --add openmrs

#copy configs
mkdir -p /opt/openmrs/openmrs/WEB-INF/classes/ && cp /opt/openmrs/etc/log4j.xml /opt/openmrs/openmrs/WEB-INF/classes/
cp -f /opt/openmrs/etc/web.xml /opt/openmrs/openmrs/WEB-INF/

# permissions
chown -R bahmni:bahmni /opt/openmrs
chown -R bahmni:bahmni /var/log/openmrs
chown -R bahmni:bahmni /var/run/openmrs
chown -R bahmni:bahmni /etc/init.d/openmrs
chown -R bahmni:bahmni /etc/openmrs

