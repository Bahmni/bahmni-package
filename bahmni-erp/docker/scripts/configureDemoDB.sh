#!/bin/bash

cd /resources/
psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -f setupDB.sql
psql -U ${POSTGRES_USER} -d odoo -f odoo_demo_dump.sql
