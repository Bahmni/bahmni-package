#!/bin/sh
nohup java -jar $SERVER_OPTS /opt/openmrs/lib/openmrs.jar > /var/log/openmrs/openmrs.log 2>/var/log/openmrs/openmrs.log < /dev/null &
echo $! > /var/run/openmrs/openmrs.pid
