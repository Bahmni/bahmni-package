#!/bin/bash

rm -f /usr/bin/bahmni
ln -s /opt/bahmni-installer/bin/bahmni /usr/bin/bahmni
ln -s /opt/bahmni-installer/etc/rpm_versions.yml /etc/bahmni-installer/rpm_versions.yml