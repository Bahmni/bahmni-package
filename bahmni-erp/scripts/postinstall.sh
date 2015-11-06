#!/bin/bash

cp -f /opt/bahmni-erp/etc/openerp /etc/init.d/openerp
ln -s /opt/bahmni-erp /etc/openerp

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
sudo python setup.py -q install
cp openerp-server /opt/bahmni-erp
cp install/openerp-server.conf /opt/bahmni-erp
cp -r /opt/bahmni-erp/bahmni-addons/* /usr/lib/python2.6/site-packages/openerp-7.0_20130301_002301-py2.6.egg/openerp/addons
