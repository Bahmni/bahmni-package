FROM postgres:9.6-alpine

COPY docker/setupDB.sql /resources/setupDB.sql
COPY resources/odoo_demo_dump.sql /resources/odoo_demo_dump.sql
COPY docker/scripts/configureDemoDB.sh /docker-entrypoint-initdb.d/configureDemoDB.sh