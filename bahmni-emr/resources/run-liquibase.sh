#!/bin/sh
set -e -x

. /etc/openmrs/bahmni-emr.conf

java $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$COMMON_CLASSPATH --changeLogFile=liquibase-core-data.xml $CREDS update
java $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$COMMON_CLASSPATH --changeLogFile=liquibase-update-to-latest.xml $CREDS update
