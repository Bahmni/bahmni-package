#!/bin/bash
set -xe
#Building bahmni core which has embedded Tomcat Server
cd bahmni-package && ./gradlew -PbahmniRelease=${BAHMNI_VERSION} :core:clean :core:build
cp core/build/libs/core-1.0-SNAPSHOT.jar bahmni-erp-connect/docker/bahmni-core.jar
cd ..

cd bahmni-package/bahmni-erp-connect
#Building Docker images
ODOO_CONNECT_IMAGE_TAG=${BAHMNI_VERSION}-${GITHUB_RUN_NUMBER}
docker build -t bahmni/odoo-connect:${ODOO_CONNECT_IMAGE_TAG} -f docker/Dockerfile  . --no-cache
