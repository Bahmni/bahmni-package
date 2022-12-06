#!/bin/bash

REGISTERED_PATIENTS_QUERY=`cat /app/scripts/reports/sql/registeredPatients.sql`
echo "REGISTERED_PATIENTS_QUERY-------"
echo "'"${REGISTERED_PATIENTS_QUERY}"'"

echo "Waiting for Metabase to start"
while (! curl -s -m 5 http://${MB_HOST}:${MB_PORT}/api/session/properties -o /dev/null); do sleep 5; done

echo "Metabase initiated successfully."




source /app/scripts/user/create_admin.sh

source /app/scripts/database/create_openmrs_db.sh

source /app/scripts/reports/create_collection.sh

source /app/scripts/reports/adding_reports.sh
