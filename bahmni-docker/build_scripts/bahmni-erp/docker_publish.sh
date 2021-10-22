#!/bin/bash
set -e
ODOO_IMAGE_TAG=${BAHMNI_VERSION}-${GITHUB_RUN_NUMBER}
echo ${DOCKER_HUB_TOKEN} | docker login -u ${DOCKER_HUB_USERNAME} --password-stdin
echo "[INFO] Pushing build images"
docker push bahmni/odoo-10-db:fresh-${ODOO_IMAGE_TAG}
docker push bahmni/odoo-10-db:demo-${ODOO_IMAGE_TAG}
docker push bahmni/odoo-10:${ODOO_IMAGE_TAG}

echo "[INFO] Tagging build images as SNAPSHOT Images"
ODOO_SNAPSHOT_IMAGE_TAG=${BAHMNI_VERSION}-SNAPSHOT
docker tag bahmni/odoo-10-db:fresh-${ODOO_IMAGE_TAG} bahmni/odoo-10-db:fresh-${ODOO_SNAPSHOT_IMAGE_TAG}
docker tag bahmni/odoo-10-db:demo-${ODOO_IMAGE_TAG} bahmni/odoo-10-db:demo-${ODOO_SNAPSHOT_IMAGE_TAG}
docker tag bahmni/odoo-10:${ODOO_IMAGE_TAG} bahmni/odoo-10:${ODOO_SNAPSHOT_IMAGE_TAG}

echo "[INFO] Pushing SNAPSHOT images"
docker push bahmni/odoo-10-db:fresh-${ODOO_SNAPSHOT_IMAGE_TAG}
docker push bahmni/odoo-10-db:demo-${ODOO_SNAPSHOT_IMAGE_TAG}
docker push bahmni/odoo-10:${ODOO_SNAPSHOT_IMAGE_TAG}

docker logout
