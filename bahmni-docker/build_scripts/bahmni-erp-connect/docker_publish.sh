#!/bin/bash
set -e
ODOO_CONNECT_IMAGE_TAG=${BAHMNI_VERSION}-${GITHUB_RUN_NUMBER}
echo ${DOCKER_HUB_TOKEN} | docker login -u ${DOCKER_HUB_USERNAME} --password-stdin
docker push bahmni/odoo-connect:${ODOO_CONNECT_IMAGE_TAG}
docker logout
