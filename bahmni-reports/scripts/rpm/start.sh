#!/bin/sh
nohup java -jar $SERVER_OPTS /opt/bahmni-reports/lib/bahmni-reports.jar &
echo $! > /var/run/bahmni-reports/bahmni-reports.pid
