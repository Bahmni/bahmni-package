#!/bin/sh
set -e -x

. /etc/bahmni-reports/bahmni-reports.conf
if [ -f /etc/bahmni-installer/bahmni.conf ]; then
. /etc/bahmni-installer/bahmni.conf
fi

CHANGE_LOG_TABLE="-Dliquibase.databaseChangeLogTableName=liquibasechangelog -Dliquibase.databaseChangeLogLockTableName=liquibasechangeloglock -DschemaName=openmrs"
LIQUIBASE_JAR="/opt/openmrs/openmrs/WEB-INF/lib/liquibase-core-2.0.5.jar"
DRIVER="com.mysql.jdbc.Driver"
CLASSPATH="/opt/bahmni-reports/bahmni-reports/WEB-INF/lib/mysql-connector-java-5.1.6.jar"
CHANGE_LOG_FILE="/opt/bahmni-reports/bahmni-reports/WEB-INF/classes/liquibase.xml"

java $CHANGE_LOG_TABLE  -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$CLASSPATH --changeLogFile=$CHANGE_LOG_FILE --url=jdbc:mysql://$OPENMRS_DB_SERVER:3306/openmrs --username=$OPENMRS_DB_USERNAME --password=$OPENMRS_DB_PASSWORD update


