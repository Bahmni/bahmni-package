#!/bin/sh

nohup java -jar $SERVER_OPTS $DEBUG_OPTS /opt/bahmni-pacs/lib/pacs-integration.jar &
echo $! > /var/run/bahmni-pacs/pacs-integration.pid
