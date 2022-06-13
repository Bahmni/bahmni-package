Bahmni Docker
===============

This directory contains bahmni dockerization replated scripts and files.

This is a Work In Progress directory.

## Table of Contents
* [Prerequisites](#prerequisites)
* [Profile Configuration](#profile-configuration)
* [Running Bahmni with default images](#running-bahmni-with-default-images)
* [One-time Setup for Odoo](#one-time-setup-for-odoo)
* [One-time Setup for OpenMRS](#one-time-setup-for-openmrs)
* [Odoo not synchronizing old patient data](#odoo-not-synchronizing-old-patient-data)
* [Overriding Default Config](#overriding-default-config)
* [Environment Configuration](#environment-configuration)
    * [Atomfeed Configuration](#atomfeed-configurations)
    * [OpenElis Configuration](#openelis-configurations)
    * [Odoo Configuration](#odoo-configurations)
    * [Odoo Connect Configuration](#odoo-connect-configurations)
    * [OpenMRS Configuration](#openmrs-configurations)
    * [Bahmni Web Configuration](#bahmni-web-configurations)
    * [Implementer Interface Configurations](#implementer-interface-configurations)
    * [Bahmni Reports Configurations](#bahmni-reports-configurations)
* [Proxy Service](#proxy-service)
* [Building OpenElis Images Locally](#building-openelis-images-locally)
* [Loading Additional Addons to Odoo](#loading-additional-addons-to-odoo)
* [Developing Bahmni Odoo Modules](#developing-bahmni-odoo-modules)
* [Building Odoo Connect Image Locally](#building-odoo-connect-image-locally)
* [Adding / Upgrading OpenMRS Modules](#adding-upgrading-openmrs-modules)
* [Development on Bahmni UI](#development-on-bahmni-ui)
* [Development Setup for Implementer Interface](#development-setup-for-implementer-interface)
* [Adding Custom Reports](#adding-custom-reports)

# Prerequisites
## Docker Installations
You can install Docker from [here](https://docs.docker.com/engine/install/). Choose the appropriate installers for your host machine and follow the instructions mentioned for the host platform.  MacOS: You can get the dmg file for Docker [here](https://store.docker.com/editions/community/docker-ce-desktop-mac). 

Note: If you are using Docker Desktop for Mac / Docker Desktop for Windows , it is recommended to increase the Memory resource to **at-least 8GB**. Please find the reference for [Mac](https://docs.docker.com/desktop/mac/) / [Windows](https://docs.docker.com/desktop/windows/).

Once you have Docker installed, ensure that you are running the daemon. If you want to tune and configure docker, please find detailed information [here](https://docs.docker.com/engine/admin/)

## Docker-Compose Installations

**Note** : If you are using Docker Desktop for Mac / Docker Desktop for Windows, then docker-compose comes bundled with docker and you need not follow the below steps. But make sure to disable Experimental Features for docker-compose from your Docker Dashboard preferences. For other operating systems, you can install docker compose from [here](https://docs.docker.com/compose/install/).

Currently Bahmni has been tested on **docker-compose version 1.29.2**. If you are using older versions of docker-compose, please upgrade to the latest version. You can check docker compose version by running `docker-compose version`

## Adding SSL Certificate
A self signed OpenSSL Certificate has been generated and bundled in the `bahmni-proxy` image. You can generate your own certificate and volume mount the folder containing the certificate to `/etc/tls` by uncommenting the lines in `docker-compose.yml`. 
```
volumes: 
   - ${CERTIFICATE_PATH}:/etc/tls
```
Replace the `${CERTIFICATE_PATH}` to the path at which the certificate and key file are present. Also make sure to name the certificate file as `cert.pem` and key file as `key.pem`

Note: Self-signed certificates are inherently not trusted by your browser because a certificate hasn't signed by trusted Certificate Authority

To generate a trusted SSL Certificate, required dependencies bundled in the `bahmni-proxy` image. You need to run the following command. It will generate certificate and replace it with `/etc/tls/cert.pem` and `/etc/tls/key.pem`
```
docker exec -it {{PROXY_CONTAINER_NAME/ID}} sh -c \
   "certbot certonly --webroot -w /usr/local/apache2/htdocs -d {{DOMAIN_NAME}} --email {{EMAIL}} \
      --agree-tos --noninteractive ;
   cp /etc/letsencrypt/live/{{DOMAIN_NAME}}/fullchain.pem /etc/tls/cert.pem ;
   cp /etc/letsencrypt/live/{{DOMAIN_NAME}}/privkey.pem /etc/tls/key.pem"
``` 
Restart the proxy container `docker restart {PROXY_CONTAINER_NAME/ID}}`

# Profile Configuration
Bahmni docker-compose has been configured with profiles which allows you to run the required services. More about compose profiles can be found [here](https://docs.docker.com/compose/profiles/). The list of different profiles can be found below.

Note: `proxy` is a generic service and it will start always irrespective of below profiles.

| Profile               | Application                          | Services                                  |
|:----------------------|:-------------------------------------|:------------------------------------------|
| default               | All applications                     | All service defined in docker-compose.yml |
| openelis              | OpenELIS                             | openelis, openelisdb                      |
| odoo                  | Odoo                                 | odoo, odoodb                              |
| openmrs               | Bahmni EMR                           | openmrs, openmrsdb, bahmni-web            |
| implementer-interface | Implementer Interface (Form Builder) | openmrs, openmrsdb, implementer-interface |
| reports               | Bahmni Reports                       | reports, reportsdb                        |


Profiles can be set by changing the `COMPOSE_PROFILES` variable in .env variable. You can set multiple profiles by comma seperated values.
Example: COMPOSE_PROFILES=openelis,odoo. You can also pass this as an argument with docker-compose up command. Example: `docker-compose --profile odoo up` (or) `docker-compose --profile odoo --profile openelis up`

# Running Bahmni with default images
### Starting all Bahmni Components
1. Navigate to `bahmni-docker` directory in a terminal.
2. Run `docker-compose up` .
    This pulls default images from docker hub and starts the application with demo database. Also `docker-compose up -d` can be used to run in detach mode.
3. After the containers spin up, you will be able to access different components at below mentioned configurations.

**Note:**
* When Bahmni docker-compose comes up, it reads the `.env` for all configuration settings like DB name, URL, ports, credentials, etc. You can change those to suit your needs. For more details on configuration options, see [Environment Configuration](#environment-configuration).
* By default the docker containers use Demo database image. One can also choose a fresh DB, but recommended to use demoDB if you are new to Bahmni and wish to have some pre-created master data, forms, terminology and patients. 
* To see the list of existing patients in Bahmni, go to Bahmni web UI, Registration Module, and for Patient Name type "%" (percentage sign) in the search box.


| Application Name      | URL                                    | Default Credentials                            | Notes                                                                                                                                                                                |
|:----------------------|:---------------------------------------|:-----------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Bahmni EMR            | http://localhost/bahmni/home           | Username: `superman` <br> Password: `Admin123` | If you use fresh db images, then you need to configure locations, visits etc as mentioned [here](https://bahmni.atlassian.net/wiki/spaces/BAH/pages/34013673/OpenMRS+configuration). |
| OpenMRS               | http://localhost/openmrs               | Username: `superman` <br> Password: `Admin123` | Perfom [one-time](#one-time-setup-for-openmrs) setup                                                                                                                                 |
| OpenElis              | http://localhost/openelis              | Username: `admin` <br> Password: `adminADMIN!` | -                                                                                                                                                                                    |
| Odoo                  | http://localhost:8069                  | Username: `admin` <br> Password: `admin`       | Perfom [one-time](#one-time-setup-for-odoo) setup                                                                                                                                    |
| Implementer Interface | http://localhost/implementer-interface | Username: `superman` <br> Password: `Admin123` | -                                                                                                                                                                                    |
| Bahmni Reports        | http://localhost/bahmni-reports        | Username: `superman` <br> Password: `Admin123` | Openmrs profile should be running                                                                                                                                                    |



### Cleaning All Bahmni Application Data

Warning: Do this step carefully! This will lead to loss of database and application data.
* From the `bahmni-docker` directory in a terminal run, `docker-compose down -v` . This brings down the containers and destroys the *volumes* attached to the containers.

# One-time Setup for Odoo
The below steps needs to be performed only once when Odoo is created.
1. Once the container spins up, login to the application.
2. Navigate to `Apps` from the menu bar.
3. Click on `Bahmni Account` app and then click on `Upgrade`.
4. Wait for the upgrade to complete and you will redirected to home page.
5. After redirection, refresh your page once.

Now Odoo should be working fine. If you don't see old patient data coming into Odoo in 10 mins, please read [Odoo not synchronizing old patient data](#odoo-not-synchronizing-old-patient-data)

# One-time Setup for OpenMRS:
The below steps needs to performed only once after OpenMRS application is loaded.
1. When OpenMRS is completely loaded, login to the application at `<host>/openmrs`
2. Navigate to Administration -> Maintenance -> Search Index.
3. In that page click on `Rebuild Search Index`
4. This rebuilds concept index of OpenMRS application.

# Odoo not synchronizing old patient data
Perform the followinng steps if older patient data is not being sent to Odoo. This likely happened because the ATOM Feed reader has already exhausted its max retry limit for failed events (by default set to 5 times). You can set the Failed events retry back to 1, and that should sync them immediately. Steps to fix this:
1. Open terminal in your local machine, in `bahmni-docker` folder.
2. Execute `docker ps` to see the list of running containers.
3. Connect to the Odoo postgres DB container by executing the command: `docker container exec -it  bahmni-docker_odoodb_1  /bin/bash`
where `bahmni-docker_odoodb_1` is the name of the odoo postgres container. You should now be within the container. 
4. Connect to the postgres console using command: `psql -Uodoo odoo`. For more info on how to connect to Bahmni Databases, refer to this wiki page: [Connecting to various databases](https://bahmni.atlassian.net/wiki/spaces/BAH/pages/49545219/Connecting+to+various+databases).
5. In the psql prompt type: `select count(*) from failed_events;` This will show you the number of failed events. 
6. If 1 or more events are there, then you can fire the query: `select id,retries from failed_events;`. You should see all failed events have reached their retry limit.
7. Fire an *update* statement to reset the retry count for all failed events: `update failed_events set retries=1;`
8. Now in about a minute, all failed events should be processed and old patient data should get synced to Odoo.
9. To exit the container, first type `\q` to exit postgres shell, and then type `exit` to exit bash shell without stopping the postgres container. 



# Overriding Default Config
Certain services(OpenMRS, OpenELIS, Bahmni Web, Bahmni Reports) of Bahmni comes with default config loaded. You can find the default_config [here](https://github.com/Bahmni/default-config).

You can override these configurations by setting the path to your config folder using the `BAHMNI_CONFIG_PATH` environment varibale.

Note: Make sure your config directory follows the same structure as default_config.

Once you have created the config files, uncomment the volume mount in the required services which begins with BAHMNI_CONFIG_PATH.


# Environment Configuration:
* The list of configurable environment variables can be found in the `.env` file.
* The `.env ` file can be modified to customise the application.
## Atomfeed Configurations:
The default values specified for the below variables are for services running in Docker. It is recommened to update only when you need to connect with a service running in a different host. (Example: Vagrant).
Note: When connected with a different host, the master data should match. Otherwise you may face issues with atomfeed sync.

| Variable Name              | Description                                              |
|:---------------------------|:---------------------------------------------------------|
| OPENMRS_HOST               | Specifies the OpenMRS host to connect for Atomfeed Sync  |
| OPENMRS_PORT               | Specifies port of OpenMRS to connect for Atomfeed Sync   |
| OPENMRS_ATOMFEED_USER      | Username for Atomfeed to connect with OpenMRS            |
| OPENMRS_ATOMFEED_PASSWORD  | Password for Atomfeed to connect with OpenMRS            |
| OPENELIS_HOST              | Specifies the OpenELIS host to connect for Atomfeed Sync |
| OPENELIS_PORT              | Specifies port of OpenELIS to connect for Atomfeed Sync  |
| OPENELIS_ATOMFEED_USER     | Username for Atomfeed to connect with OpenElis           |
| OPENELIS_ATOMFEED_PASSWORD | Password for Atomfeed to connect with OpenElis           |
| ODOO_HOST                  | Specifies the Odoo host to connect for Atomfeed Sync     |
| ODOO_PORT                  | Specifies port of Odoo to connect for Atomfeed Sync      |
| ODOO_ATOMFEED_USER         | Username for Atomfeed to connect with Odoo               |
| ODOO_ATOMFEED_PASSWORD     | Password for Atomfeed to connect with Odoo               |

## OpenElis Configurations:

| Variable Name         | Description                                                                                                                                                                                                                                                                                                                                                               |
|:----------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| OPENELIS_IMAGE_TAG    | This value tells which image version to  be used for OpenElis Application. List of tags can be found at [bahmni/openelis - Tags](https://hub.docker.com/r/bahmni/openelis/tags) .                                                                                                                                                                                         |
| OPENELIS_DB_IMAGE_TAG | This value tells which image version to be used for OpenElis Database. There are two variants available. <br>**fresh db** - Has only schema and default data.<br>**demo db** - Has schema and demo data loaded.  <br>List of image tags can be found at [bahmni/openelis-db - Tags](https://hub.docker.com/r/bahmni/openelis-db/tags) .                                   |
| BAHMNI_CONFIG_PATH    | This is a shared variable. When you want to run any liquibase migrations for OpenELIS, set the value to the path of default_config and then uncomment the volumes in openelis service. Now add liquibase changesets to default_config/openelis/migrations/liquibase.xml . Now restart OpenELIS by running `docker-compose restart openelis` from bahmni-docker directory. |
| OPENELIS_DB_DUMP_PATH | When you want to restore an existing database of OpenElis from a dump file you can set the folder path to your dump file with this variable. This is a one time setup and the restore happens only when the database is clean and fresh. So whenever you need a restore make sure you follow the steps in **Cleaning Application data**                                   |

## Odoo Configurations: 
| Variable Name     | Description                                                                                                                                                                                                                                                                                                                         |
|:------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ODOO_IMAGE_TAG    | This value tells which image version to  be used for ODoo Application. List of tags can be found at [bahmni/odoo-10 - Tags](https://hub.docker.com/r/bahmni/odoo-10/tags) .                                                                                                                                                         |
| ODOO_DB_IMAGE_TAG | This value tells which image version to be used for Odoo Database. There are two variants available. <br>**fresh db** - Has only schema and default data.<br>**demo db** - Has schema and demo data loaded.  <br>List of image tags can be found at [bahmni/odoo-10-db - Tags](https://hub.docker.com/r/bahmni/odoo-10-db/tags) .   |
| ODOO_DB_USER      | This value is used as username for Odoo Postgres DB instance. This is also referenced in Odoo application.                                                                                                                                                                                                                          |
| ODOO_DB_PASSWORD  | This value is used as password for Odoo Postgres DB instance. This is also referenced in Odoo application.                                                                                                                                                                                                                          |
| ODOO_DB_DUMP_PATH | When you want to restore an existing database of Odoo from a dump file you can set the folder path to your dump file with this variable. This is a one time setup and the restore happens only when the database is clean and fresh. So whenever you need a restore make sure you follow the steps in **Cleaning Application data** |
| EXTRA_ADDONS_PATH | When you want to installl an  additional addon, you can set the path of the root directory which contains your module directory.                                                                                                                                                                                                    |

## Odoo Connect Configurations:
| Variable Name          | Description                                                                                                                                                                              |
|:-----------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ODOO_CONNECT_IMAGE_TAG | This value tells which image version to  be used for Odoo Connect Application. List of tags can be found at [bahmni/odoo-10 - Tags](https://hub.docker.com/r/bahmni/odoo-connect/tags) . |

## OpenMRS Configurations:
| Variable Name             | Description                                                                                                                                                                                                   |
|:--------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| OPENMRS_IMAGE_TAG         | This value tells which image version to  be used for Bahmni OpenMRS. List of tags can be found at [bahmni/openmrs - Tags](https://hub.docker.com/r/bahmni/openmrs/tags) .                                     |
| OPENMRS_DB_NAME           | Database name for OpenMRS application                                                                                                                                                                         |
| OPENMRS_DB_HOST           | Host name of the MySQL Database server.                                                                                                                                                                       |
| OPENMRS_DB_USERNAME       | Username of the OpenMRS Database. OpenMRS container will create a database user with this credential.                                                                                                         |
| OPENMRS_DB_PASSWORD       | Password of the OpenMRS Database. OpenMRS container will create a database user with this credential.                                                                                                         |
| OPENMRS_DB_CREATE_TABLES  | Takes either true/false. Setting this to true, OpenMRS creates the tables necessary or running the application. Note: Set this to true only when you are running with an empty MySQL Database.                |
| OPENMRS_DB_AUTO_UPDATE    | Takes either true/false. When set to true, the migrations are run and schema is kept up to date.                                                                                                              |
| OPENMRS_MODULE_WEB_ADMIN  | Takes either true/false. Settings this to true allows you to manage OpenMRS Modules through the Web UI. It is recommened to set to false in production.                                                       |
| OPENMRS_DEBUG             | Takes either true/false. Enables the debug mode of OpenMRS                                                                                                                                                    |
| OPENMRS_UPLOAD_FILES_PATH | This variable can be specified with a directory of the host machine where the uploaded files from OpenMRS needs to be stroed. Defaults to `openmrs-uploads` directory in the docker-compose directory itself. |
| MYSQL_ROOT_PASSWORD       | This is the root password for MySQL Database Server used by OpenMRS DB service.                                                                                                                               |
| OPENMRS_DB_IMAGE_NAME     | This is used to set the type of database container to start up. You can use mysql:5.6 and set `OPENMRS_DB_CREATE_TABLES` to true to start with fresh setup with no data loaded.                               |

### Setting up a fresh OpenMRS Instance
By default, the configuration of openmrs and openmrsdb services are set to load demo data from a backup file. If you want to start the installation with a fresh schema, set `OPENMRS_DB_CREATE_TABLES` to `true` and then set `OPENMRS_DB_IMAGE_NAME` to `mysql:5.6`. Now when start the schema will be created by liquibase migrations of OpenMRS and other OMODS loaded.
## Bahmni Web Configurations:
| Variable Name        | Description                                                                                                                                                                                  |
|:---------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| BAHMNI_WEB_IMAGE_TAG | This value specifies which image version needs to be used for bahmni-web service. List of tags can be found at [bahmni/bahmni-web - Tags](https://hub.docker.com/r/bahmni/bahmni-web/tags) . |
| BAHMNI_UI_DIST_PATH  | Set this variable with the path of your dist folder of openmrs-module-bahmniapps when you want to develop on Bahmni UI.                                                                      |

## Implementer Interface Configurations:
| Variable Name                         | Description   |
| :-------------------------------------|:------------- |
| IMPLEMENTER_INTERFACE_IMAGE_TAG | This value specifies which image version needs to be used for implementer-interface service. List of tags can be found at [bahmni/implementer-interface - Tags](https://hub.docker.com/r/bahmni/implementer-interface/tags) . |
| IMPLEMENTER_INTERFACE_CODE_PATH | Set this variable with the path where you cloned implementer-interface repository when you want to do development on the same. |

## Bahmni Reports Configurations:
| Variable Name       | Description                                                                                                                                                                         |
|:--------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
 | REPORTS_IMAGE_TAG   | This value specifies which image version needs to be used for reports service. List of tags can be found at [bahmni/reports - Tags](https://hub.docker.com/r/bahmni/reports/tags) . |
 | REPORTS_DB_NAME     | Database name for Reports                                                                                                                                                           |
 | REPORTS_DB_USERNAME | Username of Reports Database                                                                                                                                                        |
 | REPORTS_DB_PASSWORD | Password of Reports Database                                                                                                                                                        |

# Proxy Service
The proxy service runs with every profile configuration. It renders the Bahmni Landing Page. Also ProxyPass and ProxyPassReverse configurations are done with this container.

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
    * `git clone https://github.com/Bahmni/bahmni-scripts.git`
    * `git clone https://github.com/Bahmni/default-config.git`

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

*Method 2:*

Note: Use this approach only when you want to manage all Bahmni OpenMRS module OMODS from Host machine.

**Prerequisite:**
You need to download or build bahmni distro zip before proceeding.

1. Extract bahmni distro zip to a directory in the host machine.
2. Set the path of the directory to `BAHMNI_OPENMRS_MODULES_PATH` in .env file.
3. Comment the openmrs-data volume in docker-compose under openmrs service.
4. Uncomment the host mounted volume in docker-compose under openmrs service.
5. After uncommenting, recreate OpenMRS by running the below commands from the directory where docker-compose is found.
    >`docker-compose rm -s -v openmrs`

    > `docker-compose up openmrs`
6. Now OpenMRS picks up omods from the host mounted directory.

# Development on Bahmni UI
When you want to develop or modify bahmni UI code, you can follow these steps.
1. Clone the [openmrs-module-bahmniapps](https://github.com/Bahmni/openmrs-module-bahmniapps) repository in your localmachine.
2. Follow the instructions in the README of the repository to install the required tools and dependencies.
3. Copy the path of `openmrs-module-bahmniapps` directory and set it to `BAHMNI_APPS_PATH` environment variable in the .env file in bahmni-package/bahmni-docker repository. Do not add / at the last.
4. Now open the docker-compose.yml file and in the bahmni-web service uncomment the volumes section with the volumes starting with BAHMNI_APPS_PATH.
5. You can start the application by running `docker-compose up`. If you have your container already running, you need to recreate it so that the volume mounted code is used. To recreate bahmni-web container run the following command from bahmni-docker directory.

    `docker-compose up -d bahmni-web`

6. Now, when you refresh your browser, you should be able to see the changes reflected.

**Note:** If your change is not reflected, it could be because your browser would be rendering it from its cache. Try the same in Incognito or after clearing cached data. Also for development it is recommended to disable caching in the browser. Go to `Inspect` and then navigate to `Network` tab where you can find `Disable Cache` checkbox.


# Development Setup for Implementer Interface
1. Clone the [implementer-interface](https://github.com/Bahmni/implementer-interface) repository in your localmachine.
2. Follow the instructions in the README of the repository to install the required tools and dependencies.
3. Copy the path of `implementer-interface` directory and set it to `IMPLEMENTER_INTERFACE_CODE_PATH` environment variable in the .env file in bahmni-package/bahmni-docker repository. Do not add / at the last.
4. Now open the docker-compose.yml file and in the implementer-interface service uncomment the volumes section. 
5. You can start implementer-interface by running `docker-compose up -d implementer-interface`. If your container is already running, you need to recreate it by the following command. `docker-compose rm -s implementer-interface && docker-compose up -d implementer-interface`
6. Now, when you have implementer-interface build running in watch mode, you should be able to see the changes on refresh of the browser. 

# Adding Custom Reports
1. When you want to add custom reports to Bahmni Reports, add the config directory path to the `BAHMNI_CONFIG_PATH` variable. Make sure to follow the directory structure of [default-config](https://github.com/Bahmni/default-config).
2. Now open the docker-compose.yml file and in the reports service uncomment the volumes section.
3. You can start reports by running `docker-compose up -d reports`. If your container is already running, you need to recreate it by the following command. `docker-compose rm -s reports && docker-compose up -d reports`
4. Now, when you have reports running, you should be able to access the reports on refresh of the browser.


# Common Troubleshooting Steps

### OpenMRS shows UI Module Not Found / OpenMRS shows Exception
- The reason for this error would be the OMODS are not loaded properly. This could happen because of inssuficient memory during initial startup by OpenMRS.
- **Fix**: Make sure you have increased your docker resources. Then try restarting OpenMRS alone with `docker-compose restart openmrs` 

