#!/bin/bash
set -e
ODOO_CONNECT_IMAGE_TAG=${BAHMNI_VERSION}-${GITHUB_RUN_NUMBER}
echo ${DOCKER_HUB_TOKEN} | docker login -u ${DOCKER_HUB_USERNAME} --password-stdin
echo "[INFO] Pushing build images"
docker push bahmni/odoo-connect:${ODOO_CONNECT_IMAGE_TAG}

echo "[INFO] Tagging build images as SNAPSHOT Images"
ODOO_CONNECT_SNAPSHOT_IMAGE_TAG=${BAHMNI_VERSION}-SNAPSHOT
docker tag bahmni/odoo-connect:${ODOO_CONNECT_IMAGE_TAG} bahmni/odoo-connect:${ODOO_CONNECT_SNAPSHOT_IMAGE_TAG}

echo "[INFO] Pushing SNAPSHOT images"
docker push bahmni/odoo-connect:${ODOO_CONNECT_SNAPSHOT_IMAGE_TAG}

docker logout
