#!/bin/bash
set -e
ODOO_CONNECT_IMAGE_TAG=${BAHMNI_VERSION}-${GO_PIPELINE_COUNTER}
echo ${DOCKER_HUB_TOKEN} | docker login -u ${DOCKER_HUB_USERNAME} --password-stdin
docker push bahmni/odoo-connect:${ODOO_CONNECT_IMAGE_TAG}
docker logout
