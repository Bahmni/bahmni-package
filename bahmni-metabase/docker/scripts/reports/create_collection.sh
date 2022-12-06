#!/bin/sh


echo "Adding Collection to Metabase"

COLLECTION_ID=$(curl -s -X POST \
    -H "Content-type: application/json" \
    -H "X-Metabase-Session: ${MB_TOKEN}" \
    http://${MB_HOST}:${MB_PORT}/api/collection \
    -d '{
        "name": "Bahmni Analytics",
        "color": "#DDDDDD"
}' | jq -r '.id')

echo "Bahmni Collection added to Metabase"
