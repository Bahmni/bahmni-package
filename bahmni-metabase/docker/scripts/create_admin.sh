#!/bin/sh

echo "Creating admin user"

SETUP_TOKEN=$(curl -s -m 5 -X GET \
    -H "Content-Type: application/json" \
    http://${METABASE_HOST}:${METABASE_PORT}/api/session/properties \
    | jq -r '.["setup-token"]'
)

MB_TOKEN=$(curl -s -X POST \
    -H "Content-type: application/json" \
    http://${METABASE_HOST}:${METABASE_PORT}/api/setup \
    -d '{
    "token": "'${SETUP_TOKEN}'",
    "user": {
        "email": "'${METABASE_ADMIN_EMAIL}'",
        "first_name": "Metabase",
        "last_name": "Admin",
        "password": "'${METABASE_ADMIN_PASSWORD}'"
    },
    "prefs": {
        "allow_tracking": false,
        "site_name": "Bahmni Metabase"
    }
}' | jq -r '.id')


echo -e "\n Admin users created!"