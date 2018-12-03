#!/bin/sh
nohup $JAVA_HOME/bin/java -jar $SERVER_OPTS $DEBUG_OPTS /opt/openmrs/lib/openmrs.jar >> /var/log/openmrs/openmrs.log 2>&1 &
echo $! > /var/run/openmrs/openmrs.pid
