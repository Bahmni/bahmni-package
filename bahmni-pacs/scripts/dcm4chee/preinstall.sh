#!/bin/bash

if [ ! -d /home/bahmni/pacs_images ];
then
    mkdir /home/bahmni/pacs_images
    if [ -d /var/lib/bahmni/dcm4chee-2.18.1-psql/server/default/archive ];
    then
        if [ ! -L /var/lib/bahmni/dcm4chee-2.18.1-psql/server/default/archive ];
        then
            sudo mv /var/lib/bahmni/dcm4chee-2.18.1-psql/server/default/archive /home/bahmni/pacs_images/
            ln -s /home/bahmni/pacs_images/ /var/lib/bahmni/dcm4chee-2.18.1-psql/server/default/
        fi
    fi
fi

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
