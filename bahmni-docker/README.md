Bahmni Docker
===============

This directory contains bahmni dockerization replated scripts and files.

This is a Work In Progress directory.

## Table of Contents
* [Profile Configuration](#profile-configuration)
* [Running the application with default images](#running-the-application-with-default-images)
* [One-time Setup for Odoo](#one-time-setup-for-odoo)
* [Environment Configuration](#environment-configuration)
    * [Atomfeed Configuration](#atomfeed-configurations)
    * [OpenElis Configuration](#openelis-configurations)
    * [Odoo Configuration](#odoo-configurations)
    * [Odoo Connect Configuration](#odoo-connect-configurations)
    * [OpenMRS Configuration](#openmrs-configurations)
* [Building OpenElis Images Locally](#building-openelis-images-locally)
* [Loading Additional Addons to Odoo](#loading-additional-addons-to-odoo)
* [Developing Bahmni Odoo Modules](#developing-bahmni-odoo-modules)
* [Building Odoo Connect Image Locally](#building-odoo-connect-image-locally)
* [Adding / Upgrading OpenMRS Modules](#adding-upgrading-openmrs-modules)

# Profile Configuration
Bahmni docker-compose has been configured with profiles which allows you to run the required services. More about compose profiles can be found [here](https://docs.docker.com/compose/profiles/). The list of different profiles can be found below.
| Profile   | Application       | Services |
| :---------|:------------------|:----------------- |
| default  | All applications    | All service defined in docker-compose.yml |
| openelis | OpenELIS            | openelis, openelisdb
| odoo     | Odoo                | odoo, odoodb |

Profiles can be set by changing the `COMPOSE_PROFILES` variable in .env variable. You can set multiple profiles by comma seperated values.
Example: COMPOSE_PROFILES=openelis,odoo. You can also pass this as an argument with docker-compose up command. Example: `docker-compose --profile odoo up` (or) `docker-compose --profile odoo --profile openelis up`

# Running the application with default images

*Requirements:*

* docker-compose

*Starting the application:*
* Navigate to `bahmni-docker` directory in a terminal.
* Run `docker-compose up` .
    This pulls default images from docker hub and starts the application with a fresh database. Also `docker-compose up -d` can be used to run in detach mode.
* After the containers spin up, you will be able to access different components at below mentioned configurations.

| Application Name   | URL             | Default Credentials | Notes|
| :------------------|:-----------------|:----------------- |:------|
| OpenElis           |http://localhost:8052/openelis| Username: admin <br> Password: adminADMIN! |-|
| Odoo               | http://localhost:8069   | Username: admin <br> Password: admin| Perfom [one-time](#one-time-setup-for-odoo) setup

*Cleaning Application Data:*

Note: Do this step only if needed. This will lead to loss of database and application data.
* From the `bahmni-docker` diretory in a terminal run, `docker-compose down -v` . This brings down the containers and destroys the volumes attached to the containers.

# One-time Setup for Odoo
The below steps needs to be performed only once when Odoo is created.
1. Once the container spins up, login to the application.
2. Navigate to `Apps` from the menu bar.
3. Click on `Bahmni Account` app and then click on `Upgrade`.
4. Wait for the upgrade to complete and you will redirected to home page.
5. After redirection, refresh your page once.

# Environment Configuration:
* The list of configurable environment variables can be found in the `.env` file.
* The `.env ` file can be modified to customise the application.
## Atomfeed Configurations:
The default values specified for the below variables are for services running in Docker. It is recommened to update only when you need to connect with a service running in a different host. (Example: Vagrant).
Note: When connected with a different host, the master data should match. Otherwise you may face issues with atomfeed sync.

| Variable Name                         | Description   |
| :-------------------------------------|:------------- |
|OPENMRS_HOST | Specifies the OpenMRS host to connect for Atomfeed Sync |
|OPENMRS_PORT | Specifies port of OpenMRS to connect for Atomfeed Sync |
|OPENMRS_ATOMFEED_USER| Username for Atomfeed to connect with OpenMRS |
|OPENMRS_ATOMFEED_PASSWORD| Password for Atomfeed to connect with OpenMRS |
|OPENELIS_HOST | Specifies the OpenELIS host to connect for Atomfeed Sync |
|OPENELIS_PORT | Specifies port of OpenELIS to connect for Atomfeed Sync |
|OPENELIS_ATOMFEED_USER| Username for Atomfeed to connect with OpenElis |
|OPENELIS_ATOMFEED_PASSWORD| Password for Atomfeed to connect with OpenElis |
|ODOO_HOST | Specifies the Odoo host to connect for Atomfeed Sync |
|ODOO_PORT | Specifies port of Odoo to connect for Atomfeed Sync |
|ODOO_ATOMFEED_USER| Username for Atomfeed to connect with Odoo |
|ODOO_ATOMFEED_PASSWORD| Password for Atomfeed to connect with Odoo |

## OpenElis Configurations:

| Variable Name                         | Description   |
| :-------------------------------------|:------------- |
| OPENELIS_IMAGE_TAG | This value tells which image version to  be used for OpenElis Application. List of tags can be found at [bahmni/openelis - Tags](https://hub.docker.com/r/bahmni/openelis/tags) . |
| OPENELIS_DB_IMAGE_TAG | This value tells which image version to be used for OpenElis Database. There are two variants available. <br>**fresh db** - Has only schema and default data.<br>**demo db** - Has schema and demo data loaded.  <br>List of image tags can be found at [bahmni/openelis-db - Tags](https://hub.docker.com/r/bahmni/openelis-db/tags) .    |
| OPENELIS_MIGRATION_XML_SCRIPTS_PATH   | When you want to run liquibase migrations you can set the folder path to your `liquibase.xml` file in this value. The migrations runs whenenver the application container is restarted. |
| OPENELIS_DB_DUMP_PATH | When you want to restore an existing database of OpenElis from a dump file you can set the folder path to your dump file with this variable. This is a one time setup and the restore happens only when the database is clean and fresh. So whenever you need a restore make sure you follow the steps in **Cleaning Application data**  |

## Odoo Configurations: 
| Variable Name                         | Description   |
| :-------------------------------------|:------------- |
| ODOO_IMAGE_TAG | This value tells which image version to  be used for ODoo Application. List of tags can be found at [bahmni/odoo-10 - Tags](https://hub.docker.com/r/bahmni/odoo-10/tags) . |
| ODOO_DB_IMAGE_TAG | This value tells which image version to be used for Odoo Database. There are two variants available. <br>**fresh db** - Has only schema and default data.<br>**demo db** - Has schema and demo data loaded.  <br>List of image tags can be found at [bahmni/odoo-10-db - Tags](https://hub.docker.com/r/bahmni/odoo-10-db/tags) .    |
| ODOO_DB_USER | This value is used as username for Odoo Postgres DB instance. This is also referenced in Odoo application.      |
| ODOO_DB_PASSWORD   | This value is used as password for Odoo Postgres DB instance. This is also referenced in Odoo application. |
| ODOO_DB_DUMP_PATH | When you want to restore an existing database of Odoo from a dump file you can set the folder path to your dump file with this variable. This is a one time setup and the restore happens only when the database is clean and fresh. So whenever you need a restore make sure you follow the steps in **Cleaning Application data**  |
| EXTRA_ADDONS_PATH | When you want to installl an  additional addon, you can set the path of the root directory which contains your module directory.   |

## Odoo Connect Configurations:
| Variable Name                         | Description   |
| :-------------------------------------|:------------- |
| ODOO_CONNECT_IMAGE_TAG | This value tells which image version to  be used for Odoo Connect Application. List of tags can be found at [bahmni/odoo-10 - Tags](https://hub.docker.com/r/bahmni/odoo-connect/tags) . |

## OpenMRS Configurations:
| Variable Name                         | Description   |
| :-------------------------------------|:------------- |
| OPENMRS_IMAGE_TAG | This value tells which image version to  be used for Bahmni OpenMRS. List of tags can be found at [bahmni/openmrs - Tags](https://hub.docker.com/r/bahmni/openmrs/tags) . |
| OPENMRS_DB_IMAGE_TAG | This value tells which image version to be used for Bahmni OpenMRS Database. There are two variants available. <br>**fresh db** - Has only schema and default data.<br>**demo db** - Has schema and demo data loaded.  <br>List of image tags can be found at [bahmni/openmrs-db - Tags](https://hub.docker.com/r/bahmni/openmrs-db/tags) .    |
| OPENMRS_DB_NAME | Database name for OpenMRS application      |
| OPENMRS_DB_HOST   | Host name of the MySQL Database server. |
| OPENMRS_DB_USERNAME | Username of the OpenMRS Database. |
| OPENMRS_DB_PASSWORD | Password of the OpenMRS Database. |
| OPENMRS_DB_CREATE_TABLES | Takes either true/false. Setting this to true, OpenMRS creates the tables neccessary or running the application. Note: Set this to true only when you are running with a plain MySQL Database Server.  |
| OPENMRS_DB_AUTO_UPDATE | Takes either true/false. When set to true, the migrations are run and schema is kept up to date. |
| OPENMRS_MODULE_WEB_ADMIN | Takes either true/false. Settings this to true allows you to manage OpenMRS Modules through the Web UI. It is recommened to set to false in production. |
| OPENMRS_DEBUG | Takes either true/false. Enables the debug mode of OpenMRS |
| OPENMRS_UPLOAD_FILES_PATH | This variable can be specified with a directory of the host machine where the uploaded files from OpenMRS needs to be stroed. Defaults to `openmrs-uploads` directory in the docker-compose directory itself. |
| MYSQL_ROOT_PASSWORD | This is the root password for MySQL Database Server running in OpenMRS Database service.   |

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
    * BAHMNI_VERSION
        * Example: `export BAHMNI_VERSION=0.93`
    * GITHUB_RUN_NUMBER - Used by CI. For Dev can be set to dev
        * Example: `export GITHUB_RUN_NUMBER=dev`

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

# Loading Additional Addons to Odoo
When you want to load additional addons to Odoo instance, you can set the EXTRA_ADDONS_PATH with the directory that contains your modules.
1. Bring down Odoo if it is already running by doing docker-compose down .
2. Set the path of your root directory of modules to EXTRA_ADDONS_PATH variable.
3. Restart Odoo instance by running `docker-compose up`
4. Login to the application
5. Navigate to `Settings` page in the web and enable Developer Mode
6. Navigate to Apps page and Click on `Update Apps List`
7. Your new module will be listed and you can install it.

For example you can download Open HRMS modules from [here](https://apps.odoo.com/apps/modules/10.0/ohrms_core/) which provides a complete HR Management System. You need to extract the downlooaded zip file and set the extracted folder path to EXTRA_ADDONS_PATH.

Note: Make sure the addons are compatible with Odoo v10.0

# Developing Bahmni Odoo Modules
Note: Do these steps only if you need to update Bahmni Odoo modules.

1. Clone the *Bahmni/odoo-modules* repo at https://github.com/Bahmni/odoo-modules.git
2. Bring Bahmni down by running `docker-compose down -v` from `bahmni-docker` directory.
3. Update the `BAHMNI_ODOO_MODULES_PATH` variable in .env file with the cloned directory path. Also update COMPOSE_PROFILE=odoo so that only odoo services start.
4. Now in `docker-compose.yml` uncomment the volume commented under odoo service.
5. Start Odoo services by running `docker-compose up`
6. Enable developer mode in Odoo by navigating to `Settings` page in Odoo Web and click `Activate the Developer Mode`
7. After you perform a change, do the following steps to reflect the changes.
8. Run `docker-compose restart odoo`
9. Now in the browser navigate to `Apps` menu. Click on the app that is updated and click `Upgrade`.
10. Now you should see the changes reflected. If not try from Step 8 & 9 once again.

# Building Odoo Connect Image Locally
*Cloning the required repositories:*
1. Create a directory where you can clone the repos and cd into it.
    * `mkdir bahmni`
    * `cd bahmni`
2. Clone the repos:
    * `git clone https://github.com/Bahmni/openerp-atomfeed-service.git`
    * `git clone https://github.com/Bahmni/bahmni-package.git`

*Compile and Building Odoo Connect:*
1. Compile openerp-atomfeed-service so that it generates the .war file.
2. Copy the generated `.war` file in `openerp-atomfeed-service/target` directory of openerp-atomfeed-service to `bahmni-package/bahmni-erp-connect/resources`


*Building the docker images:*

The docker files and scripts for Odoo Connect can be found under `bahmni-package/bahmni-erp-connect/docker`.
The docker build scripts has been written in a way to be used in Dev Environemts and also in CI Environment.
1. Setting Up Environment Variables for build:
    * BAHMNI_VERSION
        * Example: `export BAHMNI_VERSION=0.93`
    * GITHUB_RUN_NUMBER - Used by CI. For Dev can be set to dev
        * Example: `export GITHUB_RUN_NUMBER=dev`

    These values are concatenated to form the image tag. With the example values the image tag becomes `odoo-connect:0.93-dev`
2. Building images:
    * Verify your java version is 1.8 by java -version
    * From the root directory of the cloned repos run the following command.

         `./bahmni-package/bahmni-docker/build_scripts/bahmni-lab/docker_build.sh`
    * This will generate an image with the tags set as above. `bahmni/odoo-connect:0.93-dev`

*Using the local images:*

In order to use the locally built images, update `ODOO_CONNECT_IMAGE_TAG` environment variable so that docker compose picks up local images.

# Adding/ Upgrading OpenMRS Modules
OpenMRS modules can be added or upgraded through the OpenMRS Web Interface.

Note: Method 1 is the recommended approach for managing modules.

*Method 1:*
1. Set the `OPENMRS_MODULE_WEB_ADMIN` variable to `true` in the .env file.
2. Restart OpenMRS by running the follwoing commands from the directory where docker-compose file is present.
    >`docker-compose rm -s -v openmrs`

    > `docker-compose up openmrs`
3. Navigate to Administration --> Manage Modules
4. Click on Add or Upgrade module
4. When you want to add a new module click on `Choose file` in the Add Module section and then select your .omod file.
5. When you want to add a new module click on `Choose file` in the Upgrade Module section and then select your .omod file.
6. Then click on Upload. OpenMRS will pick up the new module and will be available to use.
7. The modules folder has been volume mounted and will persist until you remove your volume.
