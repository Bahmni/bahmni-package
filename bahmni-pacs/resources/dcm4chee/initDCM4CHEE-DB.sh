#!/bin/bash

. /etc/bahmni-pacs/pacs-integration.conf

if [ -f /etc/bahmni-installer/bahmni.conf ]; then
. /etc/bahmni-installer/bahmni.conf
fi

if [ "$(psql -U$POSTGRES_USER -lqt | cut -d \| -f 1 | grep -w $PACS_DB | wc -l)" -eq 0 ]
then
    export PGUSER=$POSTGRES_USER
    psql -U$POSTGRES_USER -c "CREATE DATABASE $PACS_DB;"
    psql -U$POSTGRES_USER $PACS_DB -f /var/lib/bahmni/dcm4chee-2.18.1-psql/sql/create.psql
fi
