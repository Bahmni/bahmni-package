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

mkdir -p /opt/bahmni-lab/uploaded-files
mkdir -p /home/bahmni/uploaded-files/elis

#create links
ln -s /opt/bahmni-lab/etc /etc/bahmni-lab
ln -s /opt/bahmni-lab/bin/bahmni-lab /etc/init.d/bahmni-lab
ln -s /opt/bahmni-lab/run /var/run/bahmni-lab
ln -s /opt/bahmni-lab/bahmni-lab /var/run/bahmni-lab/bahmni-lab
ln -s /opt/bahmni-lab/log /var/log/bahmni-lab
ln -s /opt/bahmni-lab/uploaded-files/elis /home/bahmni/uploaded-files/elis

#create a database if it doesn't exist and if it is not passive machine.
if [ "${IS_PASSIVE:-0}" -ne "1" ]; then
    (cd /opt/bahmni-lab/migrations && scripts/initDB.sh bahmni-base.dump)
    (cd /opt/bahmni-lab/migrations/liquibase/ && /opt/bahmni-lab/migrations/scripts/migrateDb.sh)
fi

cp -f /opt/bahmni-lab/etc/atomfeed.properties /opt/bahmni-lab/bahmni-lab/WEB-INF/classes/atomfeed.properties
cp -f /opt/bahmni-lab/etc/hibernate.cfg.xml /opt/bahmni-lab/bahmni-lab/WEB-INF/classes/us/mn/state/health/lims/hibernate/hibernate.cfg.xml

chkconfig --add bahmni-lab

# permissions
chown -R bahmni:bahmni /opt/bahmni-lab
chown -R bahmni:bahmni /var/log/bahmni-lab
chown -R bahmni:bahmni /var/run/bahmni-lab
chown -R bahmni:bahmni /etc/init.d/bahmni-lab
chown -R bahmni:bahmni /etc/bahmni-lab

