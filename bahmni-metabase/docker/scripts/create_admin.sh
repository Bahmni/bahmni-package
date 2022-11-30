#!/bin/sh

echo "Creating admin user"

SETUP_TOKEN=$(curl -s -m 5 -X GET \
    -H "Content-Type: application/json" \
    http://${MB_HOST}:${MB_PORT}/api/session/properties \
    | jq -r '.["setup-token"]'
)

curl -s -X POST \
    -H "Content-type: application/json" \
    http://${MB_HOST}:${MB_PORT}/api/setup \
    -d '{
    "token": "'${SETUP_TOKEN}'",
    "user": {
        "email": "'${MB_ADMIN_EMAIL}'",
        "first_name": "'${MB_ADMIN_FIRST_NAME}'",
        "last_name": "'${MB_ADMIN_LAST_NAME}'",
        "password": "'${MB_ADMIN_PASSWORD}'"
    },
    "prefs": {
        "allow_tracking": false,
        "site_name": "Bahmni Metabase"
    }
}'

echo -e "\n Admin users created!"