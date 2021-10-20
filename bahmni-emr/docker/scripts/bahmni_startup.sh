#!/bin/bash
set -e

# This script is used to run startup commands before starting OpenMRS distro startup script that comes with docker image. The last line starts OpenMRS script.
echo "Running Bahmnni EMR Startup Script..."

CHANGE_LOG_TABLE="-Dliquibase.databaseChangeLogTableName=liquibasechangelog -Dliquibase.databaseChangeLogLockTableName=liquibasechangeloglock -DschemaName=openmrs"
LIQUIBASE_JAR="/etc/bahmni-lab-connect/liquibase-core.jar"
DRIVER="com.mysql.jdbc.Driver"
URL="jdbc:mysql://$DB_HOST:3306/openmrs --username=$DB_USERNAME --password=$DB_PASSWORD"

echo "Substituting Environment Variables..."
envsubst < /etc/bahmni-emr/templates/bahmnicore.properties.template > /usr/local/tomcat/.OpenMRS/bahmnicore.properties
/usr/local/tomcat/wait-for-it.sh --timeout=3600 ${DB_HOST}:3306

# Running Atomfeed Migrations
java $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --url=$URL --username=$DB_USERNAME --password=$DB_PASSWORD --classpath=/etc/bahmni-lab-connect/atomfeed-client.jar:/usr/local/tomcat/webapps/openmrs.war --changeLogFile=sql/db_migrations.xml update

# Setting Soft Links from bahmni_config (Moved from bahmni-web postinstall)
ln -s /etc/bahmni_config/openmrs/obscalculator /usr/local/tomcat/.OpenMRS/obscalculator
ln -s /etc/bahmni_config/openmrs/ordertemplates /usr/local/tomcat/.OpenMRS/ordertemplates
ln -s /etc/bahmni_config/openmrs/encounterModifier /usr/local/tomcat/.OpenMRS/encounterModifier
ln -s /etc/bahmni_config/openmrs/patientMatchingAlgorithm /usr/local/tomcat/.OpenMRS/patientMatchingAlgorithm
ln -s /etc/bahmni_config/openmrs/elisFeedInterceptor /usr/local/tomcat/.OpenMRS/elisFeedInterceptor
ln -s /etc/bahmni_config /usr/local/tomcat/.OpenMRS/bahmni_config

# Running Migrations from bahmni_config (Moved from bahmni-web postinstall)
cd /etc/bahmni_config/openmrs/migrations/
java $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --url=$URL --username=$DB_USERNAME --password=$DB_PASSWORD --classpath=/usr/local/tomcat/webapps/openmrs.war --changeLogFile=liquibase.xml update
cd -

echo "Running OpenMRS Startup Script..."
./startup.sh
