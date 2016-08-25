#!/bin/sh
set -e -x

OPENMRS_DB_SERVER=localhost
OPENMRS_DB_PASSWORD=password
OPENMRS_DB_USERNAME=openmrs-user
LAB_CONNECT_OMOD="/opt/bahmni-lab-connect/openelis-atomfeed-client/openelis-atomfeed-client.omod"
LIQUIBASE_JAR="/opt/bahmni-lab-connect/lib/liquibase-core-2.0.5.jar"
OPENMRS_WAR_PATH="/opt/openmrs/openmrs.war"
ATOMFEED_CLIENT_JAR="/opt/bahmni-lab-connect/lib/atomfeed-client.jar"

if [ -f /etc/bahmni-installer/bahmni-emr-installer.conf ]; then
. /etc/bahmni-installer/bahmni-emr-installer.conf
fi

function run_openmrs_dependent_liquibase() {
	java -Dliquibase.databaseChangeLogTableName=liquibasechangelog -Dliquibase.databaseChangeLogLockTableName=liquibasechangeloglock -DschemaName=openmrs -jar $LIQUIBASE_JAR --driver=com.mysql.jdbc.Driver --url=jdbc:mysql://$OPENMRS_DB_SERVER:3306/openmrs --username=$OPENMRS_DB_USERNAME --password=$OPENMRS_DB_PASSWORD --classpath=$1:$OPENMRS_WAR_PATH --changeLogFile=$2 update
}

function run_omod_liquibase() {
	run_openmrs_dependent_liquibase $LAB_CONNECT_OMOD liquibase.xml
}

function run_atomfeed_client_liquibase() {
	run_openmrs_dependent_liquibase $ATOMFEED_CLIENT_JAR sql/db_migrations.xml
	run_omod_liquibase
}

run_atomfeed_client_liquibase