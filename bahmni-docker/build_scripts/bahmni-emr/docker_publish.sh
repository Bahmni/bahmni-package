#!/bin/bash
set -e
OPENMRS_IMAGE_TAG=${BAHMNI_VERSION}-${GITHUB_RUN_NUMBER}
echo ${DOCKER_HUB_TOKEN} | docker login -u ${DOCKER_HUB_USERNAME} --password-stdin
echo "[INFO] Pushing build images"
docker push bahmni/openmrs-db:fresh-${OPENMRS_IMAGE_TAG}
docker push bahmni/openmrs-db:demo-${OPENMRS_IMAGE_TAG}
docker push bahmni/openmrs:${OPENMRS_IMAGE_TAG}

echo "[INFO] Tagging build images as SNAPSHOT Images"
OPENMRS_SNAPSHOT_IMAGE_TAG=${BAHMNI_VERSION}-SNAPSHOT
docker tag bahmni/openmrs-db:fresh-${OPENMRS_IMAGE_TAG} bahmni/openmrs-db:fresh-${OPENMRS_SNAPSHOT_IMAGE_TAG}
docker tag bahmni/openmrs-db:demo-${OPENMRS_IMAGE_TAG} bahmni/openmrs-db:demo-${OPENMRS_SNAPSHOT_IMAGE_TAG}
docker tag bahmni/openmrs:${OPENMRS_IMAGE_TAG} bahmni/openmrs:${OPENMRS_SNAPSHOT_IMAGE_TAG}

echo "[INFO] Pushing SNAPSHOT images"
docker push bahmni/openmrs-db:fresh-${OPENMRS_SNAPSHOT_IMAGE_TAG}
docker push bahmni/openmrs-db:demo-${OPENMRS_SNAPSHOT_IMAGE_TAG}
docker push bahmni/openmrs:${OPENMRS_SNAPSHOT_IMAGE_TAG}

docker logout
