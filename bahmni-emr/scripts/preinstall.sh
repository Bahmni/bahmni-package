#!/bin/bash

# step 03 - delete existing openmrs folder
rm -rf /opt/openmrs
rm -rf /etc/openmrs

rm -rf /etc/init.d/openmrs
rm -rf /var/log/openmrs

rm -f /home/bahmni/.OpenMRS/bahmnicore.properties
rm -f /etc/httpd/conf.d/emr_ssl.conf


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
chown -R bahmni:bahmni /bahmni_temp
chmod -R 766 /bahmni_temp

