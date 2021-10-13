#!/bin/bash
set -xe

#Fetching Database Backup Data
gunzip -f -k bahmni-scripts/demo/db-backups/v0.92/odoo_backup.sql.gz
cp bahmni-scripts/demo/db-backups/v0.92/odoo_backup.sql bahmni-package/bahmni-erp/resources/odoo_demo_dump.sql

cd bahmni-package/bahmni-erp
# Unzipping Odoo Modules copied by CI
unzip -q -u -d build/ resources/odoo-modules.zip
#Building Docker images
ODOO_IMAGE_TAG=${BAHMNI_VERSION}-${GITHUB_RUN_NUMBER}
docker build -t bahmni/odoo-10-db:fresh-${ODOO_IMAGE_TAG} -f docker/db.Dockerfile  . --no-cache
docker build -t bahmni/odoo-10-db:demo-${ODOO_IMAGE_TAG} -f docker/demodb.Dockerfile  . --no-cache
docker build -t bahmni/odoo-10:${ODOO_IMAGE_TAG} -f docker/Dockerfile  . --no-cache
