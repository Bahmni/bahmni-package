Bahmni Docker
===============

This directory contains bahmni dockerization replated scripts and files.

This is a Work In Progress directory.

# Running Using Docker Compose

*Requirements:*

* docker-compose

*Starting the application:*
* Navigate to `bahmni-docker` directory in a terminal.
* Run `docker-compose up` .
    This pulls default images from docker hub and starts the application with a fresh database. Also `docker-compose up -d` can be used to run in detach mode.
* After the containers spin up, you will be able to access OpenElis at http://localhost:8052/openelis

*Cleaning Application Data:*

Note: Do this step only if needed. This will lead to loss of database data.
* If the application is already running, you can do that as a single step by doing `docker-compose down -v` .
* If you have already stopped by doing docker-compose down, then you can run `docker volume rm bahmni-docker_openelisdbdata` .

*Environment Configuration:*
* The list of configurable environment variables can be found in the `.env` file.
* The `.env ` file can be modified to customise the application.


| Variable Name                         | Description   |
| :-------------------------------------|:------------- |
| OPENELIS_IMAGE_TAG | This value tells which image version to  be used for OpenElis Application. List of tags can be found at [bahmni/openelis - Tags](https://hub.docker.com/r/bahmni/openelis/tags) . |
| OPENELIS_DB_IMAGE_TAG | This value tells which image version to be used for OpenElis Database. There are two variants available. <br>**fresh db** - Has only schema and default data.<br>**demo db** - Has schema and demo data loaded.  <br>List of image tags can be found at [bahmni/openelis-db - Tags](https://hub.docker.com/r/bahmni/openelis-db/tags) .    |
| OPENMRS_HOST | This value is used as host for syncing of data from OpenMRS Application. The default value connects with default installation of bahmni running in Vagrant.      |
| OPENELIS_MIGRATION_XML_SCRIPTS_PATH   | When you want to run liquibase migrations you can set the folder path to your `liquibase.xml` file in this value. The migrations runs whenenver the application container is restarted. |
| OPENELIS_DB_DUMP_PATH | When you want to restore an existing database of OpenElis from a dump file you can set the folder path to your dump file with this variable. This is a one time setup and the restore happens only when the database is clean and fresh. So whenever you need a restore make sure you follow the steps in **Cleaning Application data**  |


# Building OpenElis Images Locally
You can also build the docker images locally and test it with the same docker-compose file.

*Requirements:*
* git
* java version == 1.8
* docker
* docker-compose

*Cloning the required repositories:*
1. Create a directory where you can clone the repos and cd into it.
    * `mkdir bahmni`
    * `cd bahmni`
2. Clone the repos:
    * `git clone https://github.com/Bahmni/OpenElis.git`
    * `git clone https://github.com/Bahmni/bahmni-package.git`
    * `git clone https://github.com/Bahmni/emr-functional-tests.git`

*Compile and Building OpenElis:*
1. Follow the instruction in `README` of OpenElis and compile it.
2. Copy the generated `.war` file in `dist` directory of openelis to `bahmni-package/bahmni-lab/resources`
3. Copy the `OpenElis.zip` in root directory of OpenElis to `bahmni-package/bahmni-lab/resources`

*Building the docker images:*

The docker files and scripts for OpenElis can be found under `bahmni-package/bahmni-lab/docker`.
The docker build scripts has been written in a way to be used in Dev Environemts and also in CI Environment.
1. Setting Up Environment Variables for build:
    * OPENELIS_IMAGE_VERSION
        * Example: `export OPENELIS_IMAGE_VERSION=0.93`
    * GO_PIPELINE_COUNTER - Used by CI. For Dev can be set to dev
        * Example: `export GO_PIPELINE_COUNTER=dev`

    These values are concatenated to form the image tag. With the example values the image tag becomes `openelis:0.93-dev`
2. Building images:
    * Verify your java version is 1.8 by java -version
    * From the root directory of the cloned repos run the following command.

         `./bahmni-package/bahmni-docker/build_scripts/bahmni-lab/docker_build.sh`
    * This will generate three images with the tags set as above.
        1. `bahmni/openelis:0.93-dev`
        2. `bahmni/openelis-db:fresh-0.93-dev`
        3. `bahmni/openelis-db:demo-0.93-dev`

*Using the local images:*

In order to use the locally built images, update `OPENELIS_IMAGE_TAG` and `OPENELIS_DB_IMAGE_TAG` environment variables so that docker compose picks up local images.

Note: Perform **Cleaning Application Data** before doing docker-compose up if neded.
