#!/bin/bash
set -e
ODOO_IMAGE_TAG=${BAHMNI_VERSION}-${GITHUB_RUN_NUMBER}
echo ${DOCKER_HUB_TOKEN} | docker login -u ${DOCKER_HUB_USERNAME} --password-stdin
docker push bahmni/odoo-10-db:fresh-${ODOO_IMAGE_TAG}
docker push bahmni/odoo-10-db:demo-${ODOO_IMAGE_TAG}
docker push bahmni/odoo-10:${ODOO_IMAGE_TAG}
docker logout
