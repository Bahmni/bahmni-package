## Bahmni OpenMRS (bahmni/openmrs) docker image

This directory contains build and publish scripts for use in Github Actions.

Running the build script builds three images:
1. bahmni/openmrs
2. bahmni/openmrs-db:fresh
3. bahmni/openmrs-db:demo

You can find the Dockerfiles at [bahmni-package/bahmni-emr/docker](https://github.com/Bahmni/bahmni-package/tree/master/bahmni-emr/docker) .

If you are using a fresh database instance then you might need to setup some confgurations. Please have a look at the below reference. 
1. [OpenMRS Configurations for Bahmni](https://bahmni.atlassian.net/wiki/spaces/BAH/pages/34013673/OpenMRS+configuration)
