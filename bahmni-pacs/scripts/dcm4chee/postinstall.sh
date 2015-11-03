#!/bin/bash

dcm4chee_path=/var/lib/bahmni/dcm4chee-2.18.1-psql

sudo /opt/bahmni-pacs/etc/initDCM4CHEE-DB.sh
sudo $dcm4chee_path/bin/install_jboss.sh /usr/share/jboss-4.2.3.GA

cp -f /opt/bahmni-pacs/etc/server.xml $dcm4chee_path/server/default/deploy/jboss-web.deployer/
cp -f /opt/bahmni-pacs/etc/jboss-service.xml $dcm4chee_path/server/default/conf/

#Oviyam2 steps
cp -R /opt/bahmni-pacs/etc/oviyam2.war $dcm4chee_path/server/default/deploy/
cp -f /opt/bahmni-pacs/etc/oviyam2-web.xml $dcm4chee_path/server/default/deploy/oviyam2.war/WEB-INF/web.xml

if test -d /var/lib/bahmni/archive
then
    sudo mv /var/lib/bahmni/archive $dcm4chee_path/server/default/
fi

if test -d $dcm4chee_path/server/default/work/jboss.web/localhost
then
    cp -f /opt/bahmni-pacs/etc/oviyam2-1-config.xml $dcm4chee_path/server/default/work/jboss.web/localhost/
fi

ln -s /opt/bahmni-pacs/bin/dcm4chee /etc/init.d/dcm4chee
chown -R bahmni:bahmni /etc/init.d/dcm4chee
