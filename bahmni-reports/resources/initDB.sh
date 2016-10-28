#!/bin/sh
set -e -x

. /etc/bahmni-reports/bahmni-reports.conf
if [ -f /etc/bahmni-installer/bahmni.conf ]; then
. /etc/bahmni-installer/bahmni.conf
fi

RESULT=`mysql -h $REPORTS_DB_SERVER -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD --skip-column-names -e "SHOW DATABASES LIKE 'bahmni_reports'"`
if [ "$RESULT" != "bahmni_reports" ] ; then
  mysql -h $REPORTS_DB_SERVER -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE bahmni_reports;"
  mysql -h $REPORTS_DB_SERVER -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON bahmni_reports.* TO '$REPORTS_DB_USERNAME'@'$REPORTS_DB_SERVER' identified by '$REPORTS_DB_PASSWORD' WITH GRANT OPTION; FLUSH PRIVILEGES;"
fi
