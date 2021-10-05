FROM mysql:5.6
COPY resources/openmrs_clean_dump.sql /docker-entrypoint-initdb.d
