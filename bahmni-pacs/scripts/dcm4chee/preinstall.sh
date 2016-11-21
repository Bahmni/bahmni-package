#!/bin/bash

if [ ! -d /home/bahmni/pacs_images ];
then
    mkdir /home/bahmni/pacs_images
    if [ -d /var/lib/bahmni/dcm4chee-2.18.1-psql/server/default/archive ];
    then
        if [ ! -L /var/lib/bahmni/dcm4chee-2.18.1-psql/server/default/archive ];
        then
            mv /var/lib/bahmni/dcm4chee-2.18.1-psql/server/default/archive /home/bahmni/pacs_images/
        fi
    fi
fi

rm -rf /etc/init.d/dcm4chee
rm -rf /opt/dcm4chee
rm -rf /etc/dcm4chee
rm -rf /var/lib/bahmni/dcm4chee-2.18.1-psql
rm -rf /usr/share/jboss-4.2.3.GA
rm -f /etc/httpd/conf.d/dcm4chee_ssl.conf

if [ ! -d /var/lib/bahmni ]
then
    mkdir -p /var/lib/bahmni
    chown bahmni:bahmni /var/lib/bahmni
    chmod 555 /var/lib/bahmni
fi
