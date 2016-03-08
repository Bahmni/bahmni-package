#!/bin/bash

if [[ $(pip list | grep 'bahmni') != "" ]]
then
    pip uninstall -y bahmni
fi

rm -rf /etc/bahmni-installer/deployment-artifacts/rpm_versions.yml
rm -rf /etc/bahmni-installer/deployment-artifacts/local
