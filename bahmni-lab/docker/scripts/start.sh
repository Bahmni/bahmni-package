#!/bin/sh
set -e
echo "[INFO] Running Default Liquibase migrations"
cd /opt/bahmni-lab/migrations/liquibase/ && sh /opt/bahmni-lab/migrations/scripts/migrateDb.sh
echo "[INFO] Running User Defined Liquibase migrations"
sh /opt/bahmni-lab/migrations/scripts/run-implementation-openelis-implementation.sh
echo "[INFO] Starting Application"
java -jar $SERVER_OPTS $DEBUG_OPTS /opt/bahmni-lab/lib/bahmni-lab.jar
