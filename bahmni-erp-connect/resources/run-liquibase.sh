#!/bin/sh
set -e -x

. /etc/bahmni-erp-connect/bahmni-erp-connect.conf

CHANGE_LOG_TABLE="-Dliquibase.databaseChangeLogTableName=liquibasechangelog -Dliquibase.databaseChangeLogLockTableName=liquibasechangeloglock"
LIQUIBASE_JAR="/opt/bahmni-erp-connect/bahmni-erp-connect/WEB-INF/lib/liquibase-core-2.0.3.jar"
DRIVER="org.postgresql.Driver"
CREDS="--url=jdbc:postgresql://$DB_SERVER:5432/openerp --username=$DB_USERNAME --password=$DB_PASSWORD"
CLASSPATH="/opt/openmrs/openmrs.war"
CHANGE_LOG_FILE="/opt/bahmni-erp-connect/bahmni-erp-connect/WEB-INF/classes/sql/db_migrations.xml"

java $CHANGE_LOG_TABLE  -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$CLASSPATH --changeLogFile=$CHANGE_LOG_FILE $CREDS update
