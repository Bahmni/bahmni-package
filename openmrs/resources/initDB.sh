#!/bin/sh
set -e -x

. /etc/openmrs/openmrs.conf

RESULT=`mysql -uroot -ppassword --skip-column-names -e "SHOW DATABASES LIKE 'openmrs'"`
if [ "$RESULT" != "openmrs" ]; then
    echo "openmrs database not found... Restoring a base dump"
    mysql -uroot -ppassword -e "create database openmrs"
    mysql -uroot -ppassword openmrs < scripts/mrs_base.sql
    mysql -uroot -ppassword -e "CREATE USER 'openmrs-user'@'localhost' IDENTIFIED BY '$OPENMRS_DB_PASSWORD';
    GRANT ALL PRIVILEGES ON openmrs.* TO 'openmrs-user'@'localhost' identified by '$OPENMRS_DB_PASSWORD'  WITH GRANT OPTION;"
fi
