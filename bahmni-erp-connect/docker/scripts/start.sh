#!/bin/sh
set -e

echo "[INFO] Substituting Environment Variables"
envsubst < /opt/bahmni-erp-connect/etc/erp-atomfeed.properties.template > ${WAR_DIRECTORY}/WEB-INF/classes/erp-atomfeed.properties
echo "[INFO] Running Liquibase migrations"
sh /opt/bahmni-erp-connect/etc/run-liquibase.sh
echo "[INFO] Starting Application"
java -jar $SERVER_OPTS $DEBUG_OPTS /opt/bahmni-erp-connect/lib/bahmni-erp-connect.jar
