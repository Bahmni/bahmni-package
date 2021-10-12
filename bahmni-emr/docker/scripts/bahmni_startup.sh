#!/bin/bash
set -e

# This script is used to run startup commands before starting OpenMRS distro startup script that comes with docker image. The last line starts OpenMRS script.
echo "Running Bahmnni EMR Startup Script..."
echo "Substituting Environment Variables..."
envsubst < /etc/bahmni-emr/templates/bahmnicore.properties.template > /usr/local/tomcat/.OpenMRS/bahmnicore.properties
/usr/local/tomcat/wait-for-it.sh --timeout=3600 ${DB_HOST}:3306
java -Dliquibase.databaseChangeLogTableName=liquibasechangelog -Dliquibase.databaseChangeLogLockTableName=liquibasechangeloglock -DschemaName=openmrs -jar /etc/bahmni-lab-connect/liquibase-core.jar --driver=com.mysql.jdbc.Driver --url=jdbc:mysql://$DB_HOST:3306/openmrs --username=$DB_USERNAME --password=$DB_PASSWORD --classpath=/etc/bahmni-lab-connect/atomfeed-client.jar:/usr/local/tomcat/webapps/openmrs.war --changeLogFile=sql/db_migrations.xml update

echo "Running OpenMRS Startup Script..."
./startup.sh
