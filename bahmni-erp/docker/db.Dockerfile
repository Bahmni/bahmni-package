FROM postgres:9.6-alpine

COPY docker/setupDB.sql /resources/setupDB.sql
COPY resources/odoo_clean_dump.sql /resources/odoo_clean_dump.sql
COPY docker/scripts/configureDB.sh /docker-entrypoint-initdb.d/configureDB.sh