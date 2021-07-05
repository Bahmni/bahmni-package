#!/bin/sh
# TODO BDI-2 not using JAVA_HOME to start openmrs
nohup java -jar $SERVER_OPTS $DEBUG_OPTS /opt/openmrs/lib/openmrs.jar >> /var/log/openmrs/openmrs.log 2>&1 &
echo $! > /var/run/openmrs/openmrs.pid
