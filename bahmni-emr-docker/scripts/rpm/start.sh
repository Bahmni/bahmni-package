#!/bin/sh
# TODO: Changes for Docker-Migration
java -jar $SERVER_OPTS /opt/openmrs/lib/openmrs.jar >> /var/log/openmrs/openmrs.log 2>&1 &
echo $! > /var/run/openmrs/openmrs.pid
