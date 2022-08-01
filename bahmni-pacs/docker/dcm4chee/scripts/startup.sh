#!/bin/sh
set -e
initialise_database() {
    export PGPASSWORD="${DB_PASSWORD}"
    TABLE_COUNT=$(psql "${DB_NAME}" --host "${DB_HOST}" --port "${DB_PORT}" -U "${DB_USERNAME}" -A -t -c "SELECT count(*) FROM pg_tables WHERE schemaname='public';")
    if [ "$TABLE_COUNT" = "0" ]
    then
      echo "[INFO] Initialising tables in "${DB_NAME}" database.."
      PGPASSWORD="${DB_PASSWORD}" psql "${DB_NAME}" --host "${DB_HOST}" --port "${DB_PORT}" -U "${DB_USERNAME}" -f "${DCM4CHEE_PATH}"/sql/create.psql
    else
      echo "[INFO] Database already initialised."
    fi
}

rm "${DCM4CHEE_PATH}"/server/default/deploy/pacs-postgres-ds.xml
envsubst < /etc/pacs-postgres-ds.xml.template > "${DCM4CHEE_PATH}"/server/default/deploy/pacs-postgres-ds.xml

echo "Waiting for ${DB_HOST}.."
sh wait-for.sh -t 300 "${DB_HOST}":"${DB_PORT}"

initialise_database
"${DCM4CHEE_PATH}"/bin/run.sh
