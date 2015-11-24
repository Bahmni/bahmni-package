#!/bin/sh
set -e -x

RESULT=`mysql -uroot -ppassword --skip-column-names -e "SHOW DATABASES LIKE 'openmrs'"`
if [ "$RESULT" != "openmrs" ]; then
    echo "openmrs database not found... Restoring a base dump"
    mysql -uroot -ppassword openmrs < scripts/mrs_base.sql
    mysql -uroot -ppassword -e "CREATE USER 'openmrs-user'@'localhost' IDENTIFIED BY '*';
    GRANT ALL PRIVILEGES ON openmrs.* TO 'openmrs-user'@'localhost' identified by 'password'  WITH GRANT OPTION;"
fi
