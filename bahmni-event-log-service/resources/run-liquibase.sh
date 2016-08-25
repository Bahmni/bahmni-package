#!/bin/sh
set -e -x

. /etc/bahmni-reports/bahmni-event-log-service.conf
if [ -f /etc/bahmni-installer/bahmni-event-log-installer.conf ]; then
. /etc/bahmni-installer/bahmni-event-log-installer.conf
fi

CHANGE_LOG_TABLE="-Dliquibase.databaseChangeLogTableName=liquibasechangelog -Dliquibase.databaseChangeLogLockTableName=liquibasechangeloglock -DschemaName=openmrs"
LIQUIBASE_JAR="/opt/openmrs/openmrs/WEB-INF/lib/liquibase-core-2.0.5.jar"
DRIVER="com.mysql.jdbc.Driver"
CLASSPATH="/opt/bahmni-event-log-service/event-log-service-webapp.war"
CHANGE_LOG_FILE="/opt/bahmni-event-log-service/bahmni-event-log-service/WEB-INF/classes/db/changelog/liquibase.xml"

java $CHANGE_LOG_TABLE  -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$CLASSPATH --changeLogFile=$CHANGE_LOG_FILE --url=jdbc:mysql://$OPENMRS_DB_SERVER:3306/openmrs --username=$OPENMRS_DB_USERNAME --password=$OPENMRS_DB_PASSWORD update


