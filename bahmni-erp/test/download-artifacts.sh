#!/bin/bash

. ../../test-common/test.conf

../../test-common/download-artifact.sh /go/files/OpenERP_$BRANCH/Latest/runFunctionalTestsStage/Latest/runFunctionalTestsJob/deployables/openerp-modules.zip ../resources/openerp-modules.zip
../../test-common/download-artifact.sh /go/files/OpenERP_$BRANCH/Latest/runFunctionalTestsStage/Latest/openerp-atomfeed-service/openerp-atomfeed-service.war ../resources/openerp-atomfeed-service.war