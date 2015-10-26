#!/bin/bash

# backing up existing startup script for openerp
mv /etc/init.d/openerp /etc/init.d/openerp.bak
# copying patched startup script for openerp
cp /opt/bahmni-erp/etc/openerp /etc/init.d/

adduser openerp
DIR="/var/run/openerp /var/log/openerp"
for NAME in $DIR
do
    if [ ! -d $NAME ]; then
    mkdir $NAME
    chown openerp:openerp $NAME
    fi
done

chkconfig openerp on

# permissions
chown -R openerp:openerp /opt/bahmni-erp
