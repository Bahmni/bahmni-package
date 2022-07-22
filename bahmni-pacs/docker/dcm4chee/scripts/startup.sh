#!/bin/sh
set -e

rm "${DCM4CHEE_PATH}"/server/default/deploy/pacs-postgres-ds.xml
envsubst < /etc/pacs-postgres-ds.xml.template > "${DCM4CHEE_PATH}"/server/default/deploy/pacs-postgres-ds.xml

echo "Waiting for ${DB_HOST}.."
sh wait-for.sh -t 300 "${DB_HOST}":"${DB_PORT}"

PGPASSWORD="${DB_PASSWORD}" psql "${DB_NAME}" --host "${DB_HOST}" -U "${DB_USERNAME}" -f "${DCM4CHEE_PATH}"/sql/create.psql

"${DCM4CHEE_PATH}"/bin/run.sh
