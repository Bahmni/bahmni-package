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

mkdir -p /opt/elis/uploaded-files

#create links
ln -s /opt/openelis/etc /etc/openelis
ln -s /opt/openelis/bin/openelis /etc/init.d/openelis
ln -s /opt/openelis/run /var/run/openelis
ln -s /opt/openelis/openelis /var/run/openelis/openelis
ln -s /opt/openelis/log /var/log/openelis
ln -s /opt/openelis/uploaded-files /home/bahmni/uploaded-files/elis

(cd /opt/openelis/openelis && unzip ../openelis.war)

chkconfig --add openelis

# permissions
chown -R bahmni:bahmni /opt/openelis
chown -R bahmni:bahmni /var/log/openelis
chown -R bahmni:bahmni /var/run/openelis
chown -R bahmni:bahmni /etc/init.d/openelis
chown -R bahmni:bahmni /etc/openelis

