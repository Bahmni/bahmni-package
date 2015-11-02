#!/bin/sh
set -e -x

. /etc/bahmni-web/bahmni-web.conf

CHANGE_LOG_TABLE="-Dliquibase.databaseChangeLogTableName=liquibasechangelog -Dliquibase.databaseChangeLogLockTableName=liquibasechangeloglock -DschemaName=openmrs"
LIQUIBASE_JAR="/opt/openmrs/openmrs/WEB-INF/lib/liquibase-core-2.0.5.jar"
DRIVER="com.mysql.jdbc.Driver"
CREDS="--url=jdbc:mysql://$DB_SERVER:3306/openmrs --username=$DB_USERNAME --password=$DB_PASSWORD"
CLASSPATH="/opt/openmrs/openmrs/WEB-INF/lib/mysql-connector-java-5.1.28.jar"
CHANGE_LOG_FILE="/opt/bahmni-web/etc/bahmni_config/openmrs/migrations/liquibase.xml"

java $CHANGE_LOG_TABLE  -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$CLASSPATH --changeLogFile=$CHANGE_LOG_FILE $CREDS update


