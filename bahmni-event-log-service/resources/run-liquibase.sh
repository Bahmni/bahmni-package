#!/bin/sh
set -e -x

. /etc/openmrs/openmrs.conf
if [ -f /etc/bahmni-installer/bahmni.conf ]; then
. /etc/bahmni-installer/bahmni.conf
fi

LIQUIBASE_JAR="/opt/openmrs/openmrs/WEB-INF/lib/liquibase-core-2.0.5.jar"
DRIVER="com.mysql.jdbc.Driver"
CLASSPATH="/opt/bahmni-event-log-service/bahmni-event-log-service/WEB-INF/lib/mysql-connector-java-5.1.38.jar"
CHANGE_LOG_FILE="/opt/bahmni-event-log-service/bahmni-event-log-service/WEB-INF/classes/db/changelog/liquibase.xml"

java  -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$CLASSPATH --changeLogFile=$CHANGE_LOG_FILE --url=jdbc:mysql://$OPENMRS_DB_SERVER:3306/openmrs --username=$OPENMRS_DB_USERNAME --password=$OPENMRS_DB_PASSWORD update


