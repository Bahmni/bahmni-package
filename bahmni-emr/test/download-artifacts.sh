#!/bin/bash

. ../../test-common/test.conf

../../test-common/download-artifact.sh /go/files/Bahmni_environment_$BRANCH/Latest/buildStage/Latest/buildEnvironment/bahmni-environment.zip ../resources/bahmni-environment.zip
../../test-common/download-artifact.sh /go/files/Bahmni_MRS_$BRANCH/Latest/BuildDistroStage/Latest/BahmniDistro/openmrs-distro-bahmni-artifacts/distro-$BAHMNI_VERSION-distro.zip ../resources/distro-$BAHMNI_VERSION-distro.zip
