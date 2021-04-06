#!/bin/bash

if [ -f /etc/bahmni-installer/bahmni.conf ]; then
. /etc/bahmni-installer/bahmni.conf
fi

#create links
sudo ln -s /opt/openmrs/etc /etc/openmrs
sudo ln -s /opt/openmrs/log /var/log/openmrs

. /etc/openmrs/openmrs.conf

. /etc/openmrs/bahmni-emr.conf

(cd /opt/openmrs/openmrs && unzip ../openmrs.war)
# restore mrs db dump if database doesn't exists

if [ "${IS_PASSIVE:-0}" -ne "1" ]; then
    (cd /opt/openmrs/openmrs && scripts/initDB.sh)
fi
chkconfig --add openmrs

#copy configs
sudo mkdir -p /opt/openmrs/openmrs/WEB-INF/classes/ && cp /opt/openmrs/etc/log4j.xml /opt/openmrs/openmrs/WEB-INF/classes/
sudo cp -f /opt/openmrs/etc/web.xml /opt/openmrs/openmrs/WEB-INF/

# permissions
sudo chown -R bahmni:bahmni /opt/openmrs
sudo chown -R bahmni:bahmni /var/log/openmrs
sudo chown -R bahmni:bahmni /etc/openmrs

link_dirs() {
    rm -rf /home/$OPENMRS_SERVER_USER/.OpenMRS/modules
    ln -s $MODULE_REPO /home/$OPENMRS_SERVER_USER/.OpenMRS/modules
    chown -R bahmni:bahmni $MODULE_REPO
    chown -R bahmni:bahmni /home/$OPENMRS_SERVER_USER/.OpenMRS/modules
}


run_migrations() {
    echo "Running openmrs liquibase-core-data.xml and liquibase-update-to-latest.xml"
    /opt/openmrs/etc/run-liquibase.sh liquibase-core-data.xml
    /opt/openmrs/etc/run-liquibase.sh liquibase-update-to-latest.xml
}

# TODO: this part will be moved to ansible.  Remove once its done
#copy_mailappender_jar(){
#    echo "Copying the mail-appender jar file"
#    cp -f /opt/openmrs/modules/mail-appender-*.jar /opt/openmrs/openmrs/WEB-INF/lib/
#}

create_configuration_dirs() {
    [ -d /home/$OPENMRS_SERVER_USER/.OpenMRS ] || mkdir /home/$OPENMRS_SERVER_USER/.OpenMRS
    chown -R bahmni:bahmni /home/$OPENMRS_SERVER_USER/.OpenMRS

    ln -s /opt/openmrs/bahmnicore.properties /home/$OPENMRS_SERVER_USER/.OpenMRS/bahmnicore.properties
    mkdir -p $PATIENT_IMAGES_DIR
    mkdir -p $DOCUMENT_IMAGES_DIR
    mkdir -p $UPLOADED_FILES_DIR
    mkdir -p $UPLOADED_RESULTS_DIR

    cp -f /opt/openmrs/etc/blank-user.png $PATIENT_IMAGES_DIR/blank-user.png

    chown -R bahmni:bahmni /opt/openmrs
    chmod -R 755 /opt/openmrs
    chown -R bahmni:bahmni $UPLOADS_DIR
    chmod 755 $UPLOADS_DIR;
    chmod -R 755 $PATIENT_IMAGES_DIR
    chmod -R 755 $DOCUMENT_IMAGES_DIR
    chmod -R 755 $UPLOADED_FILES_DIR
    chmod -R 755 $UPLOADED_RESULTS_DIR
}

setupConfFiles() {
    	rm -f /etc/httpd/conf.d/emr_ssl.conf
    	cp -f /opt/openmrs/etc/emr_ssl.conf /etc/httpd/conf.d/emr_ssl.conf
}

create_configuration_dirs
link_dirs


if [ "${IS_PASSIVE:-0}" -ne "1" ]; then
    run_migrations
fi
setupConfFiles
