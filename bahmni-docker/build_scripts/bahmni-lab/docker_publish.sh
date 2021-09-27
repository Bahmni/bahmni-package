#!/bin/bash
set -e
OPENELIS_IMAGE_TAG=${OPENELIS_IMAGE_VERSION}-${GITHUB_RUN_NUMBER}
echo ${DOCKER_HUB_TOKEN} | docker login -u ${DOCKER_HUB_USERNAME} --password-stdin
docker push bahmni/openelis-db:fresh-${OPENELIS_IMAGE_TAG}
docker push bahmni/openelis-db:demo-${OPENELIS_IMAGE_TAG}
docker push bahmni/openelis:${OPENELIS_IMAGE_TAG}
docker logout
