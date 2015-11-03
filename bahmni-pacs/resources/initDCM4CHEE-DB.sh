#!/bin/bash

if [ "$(psql -Upostgres -lqt | cut -d \| -f 1 | grep -w pacsdb | wc -l)" -eq 0 ]
then
    export PGUSER=postgres
    psql -Upostgres -c "CREATE DATABASE pacsdb;"
    psql -Upostgres pacsdb -f /var/lib/bahmni/dcm4chee-2.18.1-psql/sql/create.psql
fi
