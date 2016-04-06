#!/bin/bash

#create openerp user and group if doesn't exist
[ $(getent group openerp) ]|| groupadd openerp
[ $(getent passwd openerp) ] || adduser -g openerp openerp

rm -rf /opt/bahmni-erp/
rm -f /usr/bin/openerp-server
rm -rf /etc/openerp
rm -rf /etc/init.d/openerp
