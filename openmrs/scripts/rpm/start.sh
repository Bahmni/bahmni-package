#!/bin/sh
nohup java -jar $SERVER_OPTS /opt/openmrs/lib/openmrs.jar &
echo $! > /var/run/openmrs/openmrs.pid
