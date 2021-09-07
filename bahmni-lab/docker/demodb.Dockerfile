FROM postgres:9.6-alpine
COPY docker/setupDBUser.sql /docker-entrypoint-initdb.d/1_setupDBUser.sql
COPY resources/openelis_demo_dump.sql /docker-entrypoint-initdb.d/2_openelis_demo_dump.sql
