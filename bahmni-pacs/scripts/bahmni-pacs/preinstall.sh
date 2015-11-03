#!/bin/bash

if [ ! -d /var/lib/bahmni ]
then
    mkdir -p /var/lib/bahmni
    chown bahmni:bahmni /var/lib/bahmni
    chmod 555 /var/lib/bahmni
fi
