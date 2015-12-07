#!/bin/bash

. ../../test-common/test.conf

../../test-common/download-artifact.sh /go/files/Bahmni_MRS_$BRANCH/5329/FunctionalTestStage/Latest/FunctionalTests/deployables/bahmniapps.zip ../resources/bahmniapps.zip
../../test-common/download-artifact.sh /go/files/Bahmni_MRS_$BRANCH/5329/FunctionalTestStage/Latest/FunctionalTests/deployables/default_config.zip ../resources/default_config.zip
mkdir -p ../resources/client_side_logging
../../test-common/download-artifact.sh /go/files/Bahmni_MRS_$BRANCH/5329/FunctionalTestStage/Latest/FunctionalTests/deployables/client_side_logging/RotatingLogger.py ../resources/client_side_logging/RotatingLogger.py
../../test-common/download-artifact.sh /go/files/Bahmni_MRS_$BRANCH/5329/FunctionalTestStage/Latest/FunctionalTests/deployables/client_side_logging/__init__.py ../resources/client_side_logging/__init__.py
../../test-common/download-artifact.sh /go/files/Bahmni_MRS_$BRANCH/5329/FunctionalTestStage/Latest/FunctionalTests/deployables/client_side_logging/client_side_logging.py ../resources/client_side_logging/
../../test-common/download-artifact.sh /go/files/Bahmni_MRS_$BRANCH/5329/FunctionalTestStage/Latest/FunctionalTests/deployables/client_side_logging/client_side_logging.wsgi ../resources/client_side_logging/client_side_logging.wsgi
../../test-common/download-artifact.sh /go/files/Bahmni_MRS_$BRANCH/5329/FunctionalTestStage/Latest/FunctionalTests/deployables/client_side_logging/logging.yml ../resources/client_side_logging/logging.yml