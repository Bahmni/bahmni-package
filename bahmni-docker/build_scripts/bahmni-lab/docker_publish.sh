#!/bin/bash
set -e
OPENELIS_IMAGE_TAG=${OPENELIS_IMAGE_VERSION}-${GO_PIPELINE_COUNTER}
echo ${DOCKER_HUB_TOKEN} | docker login -u ${DOCKER_HUB_USERNAME} --password-stdin
docker push bahmni/openelis-db:fresh-${OPENELIS_IMAGE_TAG}
docker push bahmni/openelis-db:demo-${OPENELIS_IMAGE_TAG}
docker push bahmni/openelis:${OPENELIS_IMAGE_TAG}
docker logout
