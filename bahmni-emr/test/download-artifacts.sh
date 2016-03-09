#!/bin/bash

. ../../test-common/test.conf

../../test-common/download-artifact.sh /go/files/Bahmni_MRS_$BRANCH/71/BuildDistroStage/Latest/BahmniDistro/openmrs-distro-bahmni-artifacts/distro-$BAHMNI_VERSION-distro.zip ../resources/distro-$BAHMNI_VERSION-distro.zip
