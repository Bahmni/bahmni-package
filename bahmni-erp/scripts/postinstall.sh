#!/bin/bash

# backing up existing startup script for openerp
mv /etc/init.d/openerp /etc/init.d/openerp.bak
# copying patched startup script for openerp
cd /opt/bahmni-erp/bahmni-erp && cp openerp /etc/init.d/

# permissions
chown -R openerp:openerp /opt/bahmni-erp
