#!/bin/sh
cd /opt/bahmni-lab/migrations/liquibase/ && sh /opt/bahmni-lab/migrations/scripts/migrateDb.sh
java -jar $SERVER_OPTS $DEBUG_OPTS /opt/bahmni-lab/lib/bahmni-lab.jar
