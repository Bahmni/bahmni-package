#!/bin/bash

service dcm4chee stop

if test -d /var/lib/bahmni/dcm4chee-2.18.1-psql/server/default/archive;
then
    sudo mv /var/lib/bahmni/dcm4chee-2.18.1-psql/server/default/archive /var/lib/bahmni/
fi
