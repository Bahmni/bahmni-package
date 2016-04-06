#!/bin/bash

rm -rf /etc/init.d/dcm4chee
rm -rf /opt/dcm4chee
rm -rf /etc/dcm4chee
rm -rf /var/lib/bahmni/dcm4chee-2.18.1-psql
rm -rf /usr/share/jboss-4.2.3.GA

if [ ! -d /var/lib/bahmni ]
then
    mkdir -p /var/lib/bahmni
    chown bahmni:bahmni /var/lib/bahmni
    chmod 555 /var/lib/bahmni
fi
