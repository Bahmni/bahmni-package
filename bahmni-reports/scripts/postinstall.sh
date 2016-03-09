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

chkconfig --add bahmni-reports

link_directories(){
    #create links
    ln -s /opt/bahmni-reports/etc /etc/bahmni-reports
    ln -s /opt/bahmni-reports/bin/bahmni-reports /etc/init.d/bahmni-reports
    ln -s /opt/bahmni-reports/run /var/run/bahmni-reports
    ln -s /opt/bahmni-reports/bahmni-reports /var/run/bahmni-reports/bahmni-reports
    ln -s /opt/bahmni-reports/log /var/log/bahmni-reports
}

manage_permissions(){
    # permissions
    chown -R bahmni:bahmni /opt/bahmni-reports
    chown -R bahmni:bahmni /var/log/bahmni-reports
    chown -R bahmni:bahmni /var/run/bahmni-reports
    chown -R bahmni:bahmni /etc/init.d/bahmni-reports
    chown -R bahmni:bahmni /etc/bahmni-reports
}

run_migrations(){
    echo "Running liquibase migrations"
    /opt/bahmni-reports/etc/run-liquibase.sh >> /bahmni_temp/logs/bahmni_deploy.log 2>> /bahmni_temp/logs/bahmni_deploy.log
}

link_properties_file(){
    echo "Linking properties file"
    mkdir -p /home/$USERID/.bahmni-reports
    rm -f /home/$USERID/.bahmni-reports/bahmni-reports.properties
    ln -s /opt/bahmni-reports/etc/bahmni-reports.properties /home/$USERID/.bahmni-reports/bahmni-reports.properties
}

link_directories
manage_permissions
if [ "${IS_PASSIVE:-0}" -ne "1" ]; then
    run_migrations
fi
link_properties_file
