#!/bin/bash

rm -rf /opt/bahmni-erp/
# restoring the original openerp start/stop script
mv /etc/init.d/openerp.bak /etc/init.d/openerp
