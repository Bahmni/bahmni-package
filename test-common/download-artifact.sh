#!/bin/bash

set -e

PIPELINE_PATH=$1
DEST_FOLDER=$2

if [ -z ${PIPELINE_PATH} ] || [ -z ${DEST_FOLDER} ] ; then
    echo "[USAGE] $0 <PIPELINE_PATH> <DEST_FOLDER>"
    exit 1
fi

BASE_URL="https://ci-bahmni.thoughtworks.com"

echo "-----------------------"
echo "Downloading $1 to $2"

wget --timeout=3600 --no-check-certificate --user=${GO_USER} --password=${GO_PWD} --auth-no-challenge $BASE_URL$1 -O ${DEST_FOLDER}

