#!/bin/sh
set -e

replaceConfigFiles(){
    #TO-DO: Look for a better way to use Environemnt variables in these config files.
    ATOMFEED_PROPERTIES_FILE=${WAR_DIRECTORY}/WEB-INF/classes/atomfeed.properties
    ATOMFEED_PROPERTIES_BACKUP_FILE=${WAR_DIRECTORY}/WEB-INF/classes/atomfeed.properties.backup
    HIBERNATE_CONFIG_FILE=${WAR_DIRECTORY}/WEB-INF/classes/us/mn/state/health/lims/hibernate/hibernate.cfg.xml
    HIBERNATE_CONFIG_BACKUP_FILE=${WAR_DIRECTORY}/WEB-INF/classes/us/mn/state/health/lims/hibernate/hibernate.cfg.xml.backup
    if [ ! -f ${ATOMFEED_PROPERTIES_BACKUP_FILE} ]; then
        cp ${ATOMFEED_PROPERTIES_FILE} ${ATOMFEED_PROPERTIES_BACKUP_FILE}
    fi
    if [ ! -f ${HIBERNATE_CONFIG_BACKUP_FILE} ]; then
        cp ${HIBERNATE_CONFIG_FILE} ${HIBERNATE_CONFIG_BACKUP_FILE}
    fi
    sed "s/localhost/${OPENMRS_HOST}/" ${ATOMFEED_PROPERTIES_BACKUP_FILE} > ${ATOMFEED_PROPERTIES_FILE}
    sed "s/localhost/${OPENELIS_DB_SERVER}/" ${HIBERNATE_CONFIG_BACKUP_FILE} > ${HIBERNATE_CONFIG_FILE}
}

replaceConfigFiles
echo "[INFO] Running Default Liquibase migrations"
cd /opt/bahmni-lab/migrations/liquibase/ && sh /opt/bahmni-lab/migrations/scripts/migrateDb.sh
echo "[INFO] Running User Defined Liquibase migrations"
sh /opt/bahmni-lab/migrations/scripts/run-implementation-openelis-implementation.sh
echo "[INFO] Starting Application"
java -jar $SERVER_OPTS $DEBUG_OPTS /opt/bahmni-lab/lib/bahmni-lab.jar
