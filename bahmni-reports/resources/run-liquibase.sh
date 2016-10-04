#!/bin/sh
set -e -x

. /etc/bahmni-reports/bahmni-reports.conf
if [ -f /etc/bahmni-installer/bahmni.conf ]; then
. /etc/bahmni-installer/bahmni.conf
fi

CHANGE_LOG_TABLE="-Dliquibase.databaseChangeLogTableName=liquibasechangelog -Dliquibase.databaseChangeLogLockTableName=liquibasechangeloglock -DschemaName=$3"
LIQUIBASE_JAR="/opt/openmrs/openmrs/WEB-INF/lib/liquibase-core-2.0.5.jar"
DRIVER="com.mysql.jdbc.Driver"
CLASSPATH="/opt/bahmni-reports/bahmni-reports/WEB-INF/lib/mysql-connector-java-5.1.26.jar"
CHANGE_LOG_FILE="$1"

(cd /opt/bahmni-reports/bahmni-reports/WEB-INF/classes/ && java $CHANGE_LOG_TABLE  -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$CLASSPATH --changeLogFile=$CHANGE_LOG_FILE --url=jdbc:mysql://$2:3306/$3 --username=$4 --password=$5 update)
