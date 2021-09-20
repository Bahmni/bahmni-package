#!/bin/bash

cd /resources/
psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -f setupDB.sql &> /dev/null
if [ -f db-dump/*.dump ]; then
    echo "Loading datbase from dump file"
    for DB_DUMP_FILE in *.dump; do break; done
    pg_restore -U ${POSTGRES_USER} -d odoo db-dump/$DB_DUMP_FILE
else
    echo "Loading fresh database"
    psql -U ${POSTGRES_USER} -f odoo_clean_dump.sql &> /dev/null
fi
