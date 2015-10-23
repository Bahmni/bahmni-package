#!/bin/bash

. /etc/openmrs/openmrs.conf

. /etc/openmrs/bahmni-emr.conf

chkconfig --add bahmni-mrs

link_dirs(){
    rm -rf /home/$OPENMRS_SERVER_USER/.OpenMRS/modules
    ln -s $MODULE_REPO /home/$OPENMRS_SERVER_USER/.OpenMRS/modules
    chown -R bahmni:bahmni /opt/openmrs/modules
}

predeploy(){
    echo "Running the openmrs-predeploy.sql script"
    mysql -h${DB_SERVER} -uroot -p${DB_PASSWORD} < /opt/openmrs/etc/openmrs-predeploy.sql >> /bahmni_temp/logs/bahmni_deploy.log 2>> /bahmni_temp/logs/bahmni_deploy.log
}

run_snapshot_migration(){
    echo "Running the liquibase snapshot migrations"
    /opt/openmrs/etc/run-snapshot-liquibase.sh >> /bahmni_temp/logs/bahmni_deploy.log 2>> /bahmni_temp/logs/bahmni_deploy.log
}

run_migrations(){
    echo "Running openmrs liquibase-core-data.xml and liquibase-update-to-latest.xml"
    /opt/openmrs/etc/run-liquibase.sh  >> /bahmni_temp/logs/bahmni_deploy.log 2>> /bahmni_temp/logs/bahmni_deploy.log
}

# TODO: this part will be moved to ansible.  Remove once its done
#copy_mailappender_jar(){
#    echo "Copying the mail-appender jar file"
#    cp -f /opt/openmrs/modules/mail-appender-*.jar /opt/openmrs/openmrs/WEB-INF/lib/
#}

create_configuration_dirs(){
    ln -s /opt/openmrs/etc/bahmnicore.properties /home/$OPENMRS_SERVER_USER/.OpenMRS/bahmnicore.properties
    mkdir -p $PATIENT_IMAGES_DIR
    mkdir -p $DOCUMENT_IMAGES_DIR
    mkdir -p $UPLOADED_FILES_DIR
    mkdir -p $UPLOADED_RESULTS_DIR

    chown -R bahmni:bahmni /opt/openmrs
    chown -R bahmni:bahmni $UPLOADS_DIR
    chmod -R 774 $UPLOADS_DIR;

}

link_dirs
predeploy
run_snapshot_migration
run_migrations
create_configuration_dirs
