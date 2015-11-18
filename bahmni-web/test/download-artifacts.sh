#!/bin/bash

. ../../test-common/test.conf

../../test-common/download-artifact.sh /go/files/Bahmni_MRS_$BRANCH/Latest/FunctionalTestStage/Latest/FunctionalTests/deployables/bahmniapps.zip ../resources/bahmniapps.zip
../../test-common/download-artifact.sh /go/files/Bahmni_MRS_$BRANCH/Latest/FunctionalTestStage/Latest/FunctionalTests/deployables/default_config.zip ../resources/default_config.zip
../../test-common/download-artifact.sh /go/files/Bahmni_MRS_$BRANCH/Latest/FunctionalTestStage/Latest/FunctionalTests/deployables/client_side_logging ../resources/client_side_logging