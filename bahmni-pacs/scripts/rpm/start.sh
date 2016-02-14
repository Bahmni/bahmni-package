#!/bin/sh

nohup $JAVA_HOME/bin/java -jar $SERVER_OPTS /opt/bahmni-pacs/lib/pacs-integration.jar >> /var/log/bahmni-pacs/bahmni-pacs.log 2>&1 &
echo $! > /var/run/bahmni-pacs/pacs-integration.pid
