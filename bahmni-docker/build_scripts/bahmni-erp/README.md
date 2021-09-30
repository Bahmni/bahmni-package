## Bahmni Odoo (bahmni-erp) docker image

This directory contains build and publish scripts which is used in [Github Actions](https://github.com/Bahmni/odoo-modules/actions) .

Running the build script builds three images:
1. bahmni/odoo-10
2. bahmni/odoo-10-db:fresh
3. bahmni/odoo-10-db:demo

You can find the Dockerfiles at [bahmni-package/bahmni-erp/docker](https://github.com/Bahmni/bahmni-package/tree/master/bahmni-erp/docker) .

Note: If you face any issues after ruuning the docker-compose and performing the one-time setup, then please have a look at the folllowing links to find if you need to do any configurations or any package installation is needed.
1. [Odoo Modules - Bahmni Wiki](https://bahmni.atlassian.net/wiki/spaces/BAH/pages/900530238/Odoo+System+Configuration)
2. [Bahmni Ansible Scripts](https://github.com/Bahmni/bahmni-playbooks/blob/master/roles/bahmni-erp/tasks/main.yml)

When you want to run any commands inside the odoo container, you can get bash terminal of the container by running the following command.
>docker exec -it bahmni-docker_odoo_1 bash
