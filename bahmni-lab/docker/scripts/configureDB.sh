#!/bin/bash

cd /resources/
psql -U postgres -f setupDB.sql
psql -U postgres -d clinlims -f setupExtensions.sql
psql -U clinlims -f openelis_schema.sql
psql -U clinlims -f openelis_fresh_db_data.sql
