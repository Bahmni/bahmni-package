#!/bin/bash
set -xe

cd bahmni-package/bahmni-proxy
#Building Docker images
PROXY_IMAGE_TAG=${BAHMNI_VERSION}-${GITHUB_RUN_NUMBER}
docker build -t bahmni/proxy:${PROXY_IMAGE_TAG} -f Dockerfile . --no-cache
