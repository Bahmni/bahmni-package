#!/bin/sh

nohup $JAVA_HOME/bin/java -jar $SERVER_OPTS $DEBUG_OPTS /opt/pacs-integration/lib/pacs-integration.jar >> /var/log/pacs-integration/pacs-integration.log 2>&1 &
echo $! > /var/run/pacs-integration/pacs-integration.pid
