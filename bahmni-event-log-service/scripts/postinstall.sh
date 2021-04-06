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

chkconfig --add bahmni-event-log-service

link_directories(){
    #create links
    ln -s /opt/bahmni-event-log-service/etc /etc/bahmni-event-log-service
    ln -s /opt/bahmni-event-log-service/log /var/log/bahmni-event-log-service
}

manage_permissions(){
    # permissions
    chown -R bahmni:bahmni /opt/bahmni-event-log-service
    chown -R bahmni:bahmni /var/log/bahmni-event-log-service
    chown -R bahmni:bahmni /etc/bahmni-event-log-service
}

run_migrations(){
    echo "Running liquibase migrations"
    /opt/bahmni-event-log-service/etc/run-liquibase.sh >> /bahmni_temp/logs/bahmni_deploy.log 2>> /bahmni_temp/logs/bahmni_deploy.log
}


setupConfFiles() {
    	rm -f /etc/httpd/conf.d/bahmni_eventlog_ssl.conf
    	cp -f /opt/bahmni-event-log-service/etc/bahmni_eventlog_ssl.conf /etc/httpd/conf.d/bahmni_eventlog_ssl.conf
}


link_directories
manage_permissions
setupConfFiles
if [ "${IS_PASSIVE:-0}" -ne "1" ]; then
run_migrations
fi

