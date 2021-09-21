#!/bin/sh
set -e -x

CHANGE_LOG_TABLE="-Dliquibase.databaseChangeLogTableName=liquibasechangelog -Dliquibase.databaseChangeLogLockTableName=liquibasechangeloglock"
LIQUIBASE_JAR="${WAR_DIRECTORY}/WEB-INF/lib/liquibase-core-2.0.3.jar"
DRIVER="org.postgresql.Driver"
CREDS="--url=jdbc:postgresql://$ODOO_DB_SERVER:5432/odoo --username=$ODOO_DB_USERNAME --password=$ODOO_DB_PASSWORD"
CLASSPATH="${WAR_DIRECTORY}/WEB-INF/lib/postgresql-9.1-901.jdbc4.jar"
CHANGE_LOG_FILE="${WAR_DIRECTORY}/WEB-INF/classes/sql/db_migrations.xml"

java $CHANGE_LOG_TABLE  -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$CLASSPATH --changeLogFile=$CHANGE_LOG_FILE $CREDS update
