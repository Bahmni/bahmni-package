#!/bin/bash

rm -f /usr/bin/bahmni
ln -s /opt/bahmni-installer/bin/bahmni /usr/bin/bahmni
rm -f /etc/bahmni-installer/rpm_versions.yml
ln -s /opt/bahmni-installer/etc/rpm_versions.yml /etc/bahmni-installer/rpm_versions.yml