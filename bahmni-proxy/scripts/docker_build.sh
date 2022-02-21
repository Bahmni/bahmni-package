#!/bin/bash
set -xe

mkdir -p bahmni-proxy/resources/client_side_logging
cp ../client_side_logging/{__init__.py,client_side_logging.py,client_side_logging.wsgi,logging.yml,RotatingLogger.py} bahmni-proxy/resources/client_side_logging

cd bahmni-proxy
#Building Docker images
PROXY_IMAGE_TAG=${BAHMNI_VERSION}-${GITHUB_RUN_NUMBER}
docker build -t bahmni/proxy:${PROXY_IMAGE_TAG} -f Dockerfile . --no-cache