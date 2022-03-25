#!/bin/bash
set -xe

# Build Artifacts copied by CI to bahmni-package/bahmni-emr/resources
# distro-${BAHMNI_VERSION}-SNAPSHOT.zip

# Packaging default config to embed into default image
# Working directory : default-config
cd default-config && scripts/package.sh && cd ..
cp default-config/target/default_config.zip bahmni-package/bahmni-emr/resources/

# Using Database Backup data from emr-functional-tests repo
gunzip -f -k bahmni-scripts/demo/db-backups/v0.92/openmrs_backup.sql.gz
cp bahmni-scripts/demo/db-backups/v0.92/openmrs_backup.sql bahmni-package/bahmni-emr/resources/openmrs_demo_dump.sql

cd bahmni-package/bahmni-emr

# Downloading Atomfeed Client Jar &  Liquibase Core Jar
ATOMFEED_CLIENT_VERSION=${ATOMFEED_CLIENT_VERSION:-1.9.4}
LIQUIBASE_VERSION=${LIQUIBASE_VERSION:-2.0.5}
curl -L -o resources/atomfeed-client-${ATOMFEED_CLIENT_VERSION}.jar "https://oss.sonatype.org/content/repositories/releases/org/ict4h/atomfeed-client/${ATOMFEED_CLIENT_VERSION}/atomfeed-client-${ATOMFEED_CLIENT_VERSION}.jar"
curl -L -o resources/liquibase-core-${LIQUIBASE_VERSION}.jar "https://oss.sonatype.org/content/repositories/releases/org/liquibase/liquibase-core/${LIQUIBASE_VERSION}/liquibase-core-${LIQUIBASE_VERSION}.jar"

# Unzipping Bahmni OMODs
rm -rf build/
mkdir build/
unzip -q -u -j -d build/openmrs-modules resources/distro-0.93-SNAPSHOT-distro.zip

# Copy NDHM OMODS
cp resources/fhir2-omod-1.0.0-SNAPSHOT.omod build/openmrs-modules/
cp resources/hipmodule-omod-0.1-SNAPSHOT.omod build/openmrs-modules/

# Unzipping Default Config
unzip -q -u -d build/default_config resources/default_config.zip

# Building Docker images
OPENMRS_IMAGE_TAG=${BAHMNI_VERSION}-${GITHUB_RUN_NUMBER}
docker build -t bahmni/openmrs-db:fresh-${OPENMRS_IMAGE_TAG} -f docker/db.Dockerfile  . --no-cache
docker build -t bahmni/openmrs-db:demo-${OPENMRS_IMAGE_TAG} -f docker/demodb.Dockerfile  . --no-cache
docker build -t bahmni/openmrs:${OPENMRS_IMAGE_TAG} -f docker/Dockerfile  . --no-cache
