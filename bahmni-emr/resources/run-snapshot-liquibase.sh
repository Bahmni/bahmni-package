#!/bin/bash
set -e -x

. /etc/openmrs/bahmni-emr.conf


function run-atomfeed-client-liquibase-migration {
    echo "Running the atomfeed client liquibase migration"
    java  $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=/opt/openmrs/etc/atomfeed-client.jar:$COMMON_CLASSPATH --changeLogFile=sql/db_migrations.xml $CREDS update
}

function run-liquibase-migration {
    CHANGE_LOG_DIR=$1
    CHANGE_LOG_FILE=$2
    if [ -a $CHANGE_LOG_DIR/$CHANGE_LOG_FILE ]; then
        cd $CHANGE_LOG_DIR
        java  $CHANGE_LOG_TABLE -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$COMMON_CLASSPATH --changeLogFile=$CHANGE_LOG_FILE $CREDS update $3
    else
        echo "Could not find $1/$2 . Moving on"
    fi
}

function run-snapshot-migrations {
    run-liquibase-migration $SNAPSHOTS_DIR/$1/openmrs/resources liquibase-schema-only.xml
    run-liquibase-migration $SNAPSHOTS_DIR/$1/openmrs/resources liquibase-core-data.xml
    run-liquibase-migration $SNAPSHOTS_DIR/$1/openmrs/resources liquibase-update-to-latest.xml
    run-liquibase-migration $SNAPSHOTS_DIR/$1/bahmni-core/bahmnicore-omod migrations/dependent-modules/liquibase.xml
    run-liquibase-migration $SNAPSHOTS_DIR/$1/openmrs-atomfeed liquibase.xml
    run-liquibase-migration $SNAPSHOTS_DIR/$1/openmrs-module-appframework liquibase.xml
    run-liquibase-migration $SNAPSHOTS_DIR/$1/openmrs-module-calculation liquibase.xml
    run-liquibase-migration $SNAPSHOTS_DIR/$1/openmrs-module-metadatamapping liquibase.xml
    run-liquibase-migration $SNAPSHOTS_DIR/$1/openmrs-module-providermanagement liquibase.xml
    run-liquibase-migration $SNAPSHOTS_DIR/$1/openmrs-module-uiframework liquibase.xml
    run-liquibase-migration $SNAPSHOTS_DIR/$1/bahmni-core/bahmnicore-omod liquibase.xml
    run-liquibase-migration $SNAPSHOTS_DIR/$1/openmrs-module-bahmniapps/resources liquibase.xml
    run-liquibase-migration $SNAPSHOTS_DIR/$1 liquibase.xml
    run-liquibase-migration $SNAPSHOTS_DIR/$1/atomfeed sql/db_migrations.xml -DschemaName=openmrs
    run-liquibase-migration $SNAPSHOTS_DIR/$1/bahmni-core/openmrs-elis-atomfeed-client-omod liquibase.xml
}

for dir in  `ls $SNAPSHOTS_DIR | sort -t- -n`
do
    run-snapshot-migrations $dir
done

run-atomfeed-client-liquibase-migration
