#!/bin/bash
echo "Starting and intializing the Metabase."
/app/run_metabase.sh & /app/scripts/metabase/metabase_init.sh

wait ${!}