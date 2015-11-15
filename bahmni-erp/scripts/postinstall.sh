#!/bin/bash

export BAHMNI_ERP=/opt/bahmni-erp
cp -f $BAHMNI_ERP/etc/openerp /etc/init.d/openerp

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
chown -R openerp:openerp $BAHMNI_ERP

# installing openerp
cd $BAHMNI_ERP
tar -xvzf openerp-7.0-20130301-002301.tar.gz
cd openerp-7.0-20130301-002301
sudo python setup.py -q install
cp openerp-server $BAHMNI_ERP
cp install/openerp-server.conf $BAHMNI_ERP
cp -r $BAHMNI_ERP/bahmni-addons/* /usr/lib/python2.6/site-packages/openerp-7.0_20130301_002301-py2.6.egg/openerp/addons

rm -rf $BAHMNI_ERP/openerp-7.0-20130301-002301
rm -rf $BAHMNI_ERP/openerp-7.0-20130301-002301.tar.gz
