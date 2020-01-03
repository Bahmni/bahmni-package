#!/bin/bash

. /opt/bahmni-reports/etc/bahmni-reports.conf

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
    ln -s /opt/bahmni-reports/etc /etc/bahmni-reports
    ln -s /opt/bahmni-reports/bin/bahmni-reports /etc/init.d/bahmni-reports
    ln -s /opt/bahmni-reports/log /var/log/bahmni-reports
}

manage_permissions(){
    # permissions
    chown -R bahmni:bahmni /opt/bahmni-reports
    chown -R bahmni:bahmni /var/log/bahmni-reports
    chown -R bahmni:bahmni /etc/init.d/bahmni-reports
    chown -R bahmni:bahmni /etc/bahmni-reports
}

run_migrations(){
    echo "Running liquibase migrations"
    /opt/bahmni-reports/etc/run-liquibase.sh $1 $2 $3 $4 $5 >> /bahmni_temp/logs/bahmni_deploy.log 2>> /bahmni_temp/logs/bahmni_deploy.log
}

link_properties_file(){
    echo "Linking properties file"
    mkdir -p /home/$USERID/.bahmni-reports
    rm -f /home/$USERID/.bahmni-reports/bahmni-reports.properties
    ln -s /opt/bahmni-reports/etc/bahmni-reports.properties /home/$USERID/.bahmni-reports/bahmni-reports.properties
}

setupConfFiles() {
    rm -f /etc/httpd/conf.d/bahmni_reports_ssl.conf
    cp -f /opt/bahmni-reports/etc/bahmni_reports_ssl.conf /etc/httpd/conf.d/bahmni_reports_ssl.conf
}

create_db() {
    /opt/bahmni-reports/etc/initDB.sh 2>> /bahmni_temp/logs/bahmni_deploy.log
}

create_directories() {
    OPENMRS_SERVER_USER=bahmni
    REPORTS_SAVE_DIR=/home/$OPENMRS_SERVER_USER/reports
    mkdir $REPORTS_SAVE_DIR
    chown bahmni:bahmni $REPORTS_SAVE_DIR
}

setupConfFiles
link_directories
create_directories
manage_permissions
if [ "${IS_PASSIVE:-0}" -ne "1" ]; then
    create_db
    run_migrations liquibase.xml $OPENMRS_DB_SERVER openmrs $OPENMRS_DB_USERNAME $OPENMRS_DB_PASSWORD
    run_migrations liquibase_bahmni_reports.xml $REPORTS_DB_SERVER bahmni_reports $REPORTS_DB_USERNAME $REPORTS_DB_PASSWORD
fi
link_properties_file

chkconfig --add bahmni-reports
