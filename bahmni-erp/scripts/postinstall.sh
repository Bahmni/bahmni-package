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

set -e -x
# installing openerp
cd /opt/bahmni-erp
tar -xvzf openerp-7.0-20130301-002301.tar.gz
cd openerp-7.0-20130301-002301
sudo python setup.py install
cd ..
rm -rf openerp-7.0-20130301-002301
