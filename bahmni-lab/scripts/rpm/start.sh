#!/bin/sh
nohup java -jar $SERVER_OPTS /opt/bahmni-lab/lib/bahmni-lab.jar &
echo $! > /var/run/bahmni-lab/bahmni-lab.pid
