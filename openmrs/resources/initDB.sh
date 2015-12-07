#!/bin/sh
set -e -x

. /etc/openmrs/openmrs.conf

. /etc/bahmni-installer/bahmni.conf

RESULT=`mysql -h $OPENMRS_DB_SERVER -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD --skip-column-names -e "SHOW DATABASES LIKE 'openmrs'"`
if [ "$RESULT" != "openmrs" ] && [ "${IMPLEMENTATION_NAME:-default}" = "default" ]; then
    echo "openmrs database not found... Restoring a base dump"
    mysql -h $OPENMRS_DB_SERVER -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD  < scripts/mrs_base.sql
fi

mysql -h $OPENMRS_DB_SERVER -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD -e "CREATE USER '$OPENMRS_DB_USER'@'$OPENMRS_DB_SERVER' IDENTIFIED BY '*';
    GRANT ALL PRIVILEGES ON openmrs.* TO '$OPENMRS_DB_USER'@'$OPENMRS_DB_SERVER' identified by '$OPENMRS_DB_PASSWORD'  WITH GRANT OPTION;"
