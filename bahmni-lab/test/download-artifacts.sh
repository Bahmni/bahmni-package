#!/bin/bash

. ../../test-common/test.conf

../../test-common/download-artifact.sh /go/files/OpenElis_$BRANCH/Latest/Build/Latest/build/deployables/OpenElis.zip ../resources/OpenElis.zip
../../test-common/download-artifact.sh /go/files/OpenElis_$BRANCH/Latest/Build/Latest/build/deployables/openelis.war ../resources/openelis.war