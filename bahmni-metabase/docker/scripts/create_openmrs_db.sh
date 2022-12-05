#!/bin/sh


echo "Adding OPENMRS Database to Metabase"

curl -s -X POST \
    -H "Content-type: application/json" \
    -H "X-Metabase-Session: ${MB_TOKEN}" \
    http://${MB_HOST}:${MB_PORT}/api/database \
    -d '{
        "engine": "'${OPENMRS_DB_TYPE}'",
        "name": "'${OPENMRS_DB_HOST}'",
        "details": {
            "host": "'${OPENMRS_DB_HOST}'",
            "db": "'${OPENMRS_DB_NAME}'",
            "user": "'${OPENMRS_DB_USERNAME}'",
            "password": "'${OPENMRS_DB_PASSWORD}'"
        }
    }'

echo "OPENMRS Database added to Metabase"
