FROM mysql:5.6
COPY resources/openmrs_demo_dump.sql /docker-entrypoint-initdb.d
