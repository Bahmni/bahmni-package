#!/bin/sh
nohup java -jar $SERVER_OPTS $DEBUG_OPTS /opt/openelis/lib/openelis.jar > /var/log/openelis/openelis.log 2>/var/log/openelis/openelis.log < /dev/null &
echo $! > /var/run/openelis/openelis.pid
