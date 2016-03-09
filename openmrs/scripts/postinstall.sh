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

mkdir -p /bahmni_temp/logs
#create links
ln -s /opt/openmrs/etc /etc/openmrs
ln -s /opt/openmrs/bin/openmrs /etc/init.d/openmrs
ln -s /opt/openmrs/run /var/run/openmrs
ln -s /opt/openmrs/openmrs /var/run/openmrs/openmrs
ln -s /opt/openmrs/log /var/log/openmrs

(cd /opt/openmrs/openmrs && unzip ../openmrs.war)
# restore mrs db dump if database doesn't exists

if [ "${IS_PASSIVE:-0}" -ne "1" ]; then
    (cd /opt/openmrs/openmrs && scripts/initDB.sh)
fi
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

