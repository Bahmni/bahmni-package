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

export MOD_PROXY=/var/cache/mod_proxy

setupConfFiles() {
    rm -f /etc/httpd/conf/httpd.conf
    rm -f /etc/httpd/conf.d/ssl.conf

    ln -s /opt/bahmni-web/etc/httpd.conf /etc/httpd/conf/httpd.conf
    ln -s /opt/bahmni-web/etc/ssl.conf /etc/httpd/conf.d/ssl.conf
}

setupCacheDir(){
    rm -rf $MOD_PROXY
    mkdir $MOD_PROXY
    useradd -g apache bahmni
    chown apache:apache $MOD_PROXY
}

setupClientSideLogging(){
    mkdir -p /var/log/client-side-logs/
    touch /var/log/client-side-logs/client-side.log
    rm -rf /var/www/client_side_logging
    ln -s /opt/bahmni-web/etc/client_side_logging/ /var/www/client_side_logging
}

setupAppsAndConfig(){
    rm -rf /var/www/bahmniapps /var/www/bahmni_config
    ln -s /opt/bahmni-web/etc/bahmniapps/ /var/www/bahmniapps
    ln -s /opt/bahmni-web/etc/bahmni_config/ /var/www/bahmni_config
    #TODO: Refactor bahmni-core to link bahmni_config instead like applicationDataDirectory/<bahmni_config>/openmrs/obscalculator
    ln -s /opt/bahmni-web/etc/bahmni_config/openmrs/obscalculator /opt/openmrs/obscalculator
    ln -s /opt/bahmni-web/etc/bahmni_config/openmrs/ordertemplates /opt/openmrs/ordertemplates
    ln -s /opt/bahmni-web/etc/bahmni_config/openmrs/encounterModifier /opt/openmrs/encounterModifier
    ln -s /opt/bahmni-web/etc/bahmni_config/openmrs/patientMatchingAlgorithm /opt/openmrs/patientMatchingAlgorithm
    ln -s /opt/bahmni-web/etc/bahmni_config /opt/openmrs/bahmni_config #TODO: Why is this required?
}

runConfigMigrations(){
    ln -s /opt/bahmni-web/etc /etc/bahmni-web
    echo "Running bahmni_config migrations"
    cd /opt/bahmni-web/etc/bahmni_config/openmrs/migrations/ && /opt/bahmni-web/etc/run-liquibase.sh
}

manage_permissions(){
    # permissions
    chown -R bahmni:bahmni /opt/bahmni-web
    chown -R bahmni:bahmni /var/www/bahmniapps
    chown -R bahmni:bahmni /var/www/bahmni_config
    chown -R bahmni:bahmni /var/www/client_side_logging
    chown -R bahmni:bahmni /opt/openmrs
}

setupConfFiles
setupCacheDir
setupClientSideLogging
setupAppsAndConfig
runConfigMigrations
manage_permissions
