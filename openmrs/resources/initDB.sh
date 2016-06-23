#!/bin/sh
set -e -x

. /etc/openmrs/openmrs.conf

if [ -f /etc/bahmni-installer/bahmni.conf ]; then
. /etc/bahmni-installer/bahmni.conf
fi

RESULT=`mysql -h $OPENMRS_DB_SERVER -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD --skip-column-names -e "SHOW DATABASES LIKE 'openmrs'"`
if [ "$RESULT" != "openmrs" ] ; then
  mysql -h $OPENMRS_DB_SERVER -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE openmrs;"
  if [ "${IMPLEMENTATION_NAME:-default}" = "default" ]; then
    echo "openmrs database not found... Restoring a base dump suitable to work with default config"
    mysql -h $OPENMRS_DB_SERVER -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD openmrs < scripts/openmrs_demo_dump.sql
  else
    echo "clean openmrs database will be created with no demo data"
    mysql -h $OPENMRS_DB_SERVER -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD  < scripts/openmrs_clean_dump.sql
  fi
fi

mysql -h $OPENMRS_DB_SERVER -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD -e "CREATE USER '$OPENMRS_DB_USER'@'$OPENMRS_DB_SERVER' IDENTIFIED BY '*';
    GRANT ALL PRIVILEGES ON openmrs.* TO '$OPENMRS_DB_USER'@'$OPENMRS_DB_SERVER' identified by '$OPENMRS_DB_PASSWORD'  WITH GRANT OPTION;"
