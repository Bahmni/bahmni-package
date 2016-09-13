#!/bin/bash

. /etc/dcm4chee/dcm4chee.conf

if [ -f /etc/bahmni-installer/bahmni.conf ]; then
. /etc/bahmni-installer/bahmni.conf
fi

if [ "$(psql -h$DCM4CHEE_DB_SERVER -U$POSTGRES_USER -lqt | cut -d \| -f 1 | grep -w $PACS_DB | wc -l)" -eq 0 ]
then
    export PGUSER=$POSTGRES_USER
    psql -h$DCM4CHEE_DB_SERVER -U$POSTGRES_USER -c "CREATE DATABASE $PACS_DB;"
    psql -h$DCM4CHEE_DB_SERVER -U$POSTGRES_USER $PACS_DB -f /var/lib/bahmni/dcm4chee-2.18.1-psql/sql/create.psql
fi
