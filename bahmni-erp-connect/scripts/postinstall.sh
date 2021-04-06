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

link_directories(){
    #create links
    ln -s /opt/bahmni-erp-connect/etc /etc/bahmni-erp-connect
    ln -s /opt/bahmni-erp-connect/log /var/log/bahmni-erp-connect
}

manage_permissions(){
    # permissions
    chown -R bahmni:bahmni /opt/bahmni-erp-connect
    chown -R bahmni:bahmni /var/log/bahmni-erp-connect
    chown -R bahmni:bahmni /etc/bahmni-erp-connect
}

run_migrations(){
    echo "Running liquibase migrations"
    /opt/bahmni-erp-connect/etc/run-liquibase.sh >> /bahmni_temp/logs/bahmni_deploy.log 2>> /bahmni_temp/logs/bahmni_deploy.log
}

link_directories
manage_permissions
if [ "${IS_PASSIVE:-0}" -ne "1" ]; then
    run_migrations
fi

chkconfig --add bahmni-erp-connect
