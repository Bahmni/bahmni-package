#!/bin/sh
set -e -x

. /etc/openmrs/openmrs.conf

. /etc/bahmni-installer/bahmni.conf

RESULT=`mysql -h $OPENMRS_DB_SERVER -uroot -ppassword --skip-column-names -e "SHOW DATABASES LIKE 'openmrs'"`
if [ "$RESULT" != "openmrs" ]; then
    echo "openmrs database not found... Restoring a base dump"
    mysql -h $OPENMRS_DB_SERVER -uroot -ppassword  < scripts/mrs_base.sql
    mysql -h $OPENMRS_DB_SERVER -uroot -ppassword -e "CREATE USER 'openmrs-user'@'$OPENMRS_DB_SERVER' IDENTIFIED BY '*';
    GRANT ALL PRIVILEGES ON openmrs.* TO 'openmrs-user'@'$OPENMRS_DB_SERVER' identified by 'password'  WITH GRANT OPTION;"
fi
