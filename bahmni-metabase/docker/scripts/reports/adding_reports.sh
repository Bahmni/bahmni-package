#!/bin/sh


echo "Adding Registerd Patient Report to Metabase "

REGISTERED_PATIENTS_QUERY=`cat /app/scripts/reports/sql/registeredPatients.sql`
echo "REGISTERED_PATIENTS_QUERY Json-------"
echo '{
        "name": "Registered Patients Report",
        "collection_id": '${COLLECTION_ID}',
        "dataset_query":{"type": "native","database": '${DATABASE_ID}',"native":{
        "query":"'${REGISTERED_PATIENTS_QUERY}'"
        }},
        "display":"TABLE",
        "visualization_settings":{"table.pivot_column": "Gender", "table.cell_column": "Sr. No."}
    }'
echo "REGISTERED_PATIENTS_QUERY  Json end-------"
curl -s -X POST \
    -H "Content-type: application/json" \
    -H "X-Metabase-Session: ${MB_TOKEN}" \
    http://${MB_HOST}:${MB_PORT}/api/card \
    -d '{
        "name": "Registered Patients Report",
        "collection_id": '${COLLECTION_ID}',
        "dataset_query":{"type": "native","database": '${DATABASE_ID}',"native":{
        "query":"'${REGISTERED_PATIENTS_QUERY}'"
        }},
        "display":"TABLE",
        "visualization_settings":{"table.pivot_column": "Gender", "table.cell_column": "Sr. No."}
    }'

echo "Bahmni Report added to Metabase"
