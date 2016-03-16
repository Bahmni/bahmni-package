#!/bin/bash

. ../../test-common/test.conf

../../test-common/download-artifact.sh /go/files/Bahmni_Reports_$BRANCH/Latest/BuildStage/Latest/Build-Bahmni-Reports/deployables/bahmnireports.war ../resources/bahmnireports.war
