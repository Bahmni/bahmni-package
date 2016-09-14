#!/bin/sh
set -e -x

. /etc/bahmni-reports/bahmni-reports.conf
if [ -f /etc/bahmni-installer/bahmni-emr-installer.conf ]; then
. /etc/bahmni-installer/bahmni-emr-installer.conf
fi

RESULT=`mysql -h $OPENMRS_DB_SERVER -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD --skip-column-names -e "SHOW DATABASES LIKE 'bahmni_reports'"`
if [ "$RESULT" != "bahmni_reports" ] ; then
  mysql -h $OPENMRS_DB_SERVER -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE bahmni_reports;"
  mysql -h $OPENMRS_DB_SERVER -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON bahmni_reports.* TO '$OPENMRS_DB_USERNAME'@'$OPENMRS_DB_SERVER' identified by '$OPENMRS_DB_PASSWORD'  WITH GRANT OPTION;"
fi
