#!/bin/sh
nohup java -jar $SERVER_OPTS $DEBUG_OPTS /opt/bahmni-reports/lib/bahmni-reports.jar >> /var/log/bahmni-reports/bahmni-reports.log 2>&1 &
echo $! > /var/run/bahmni-reports/bahmni-reports.pid
