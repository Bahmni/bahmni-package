#!/bin/bash

#create openerp user and group if doesn't exist
[ $(getent group odoo) ]|| groupadd odoo
[ $(getent passwd odoo) ] || adduser -g odoo odoo

rm -rf /opt/bahmni-erp
rm -f /usr/bin/odoo-server
rm -rf /etc/odoo
rm -rf /etc/odoo.conf
rm -rf /etc/rc.d/init.d/odoo


