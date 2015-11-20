#!/bin/bash

export BAHMNI_ERP=/opt/bahmni-erp

manage_permissions(){
    adduser openerp
    chown -R openerp:openerp $BAHMNI_ERP
    chown openerp:openerp /var/log/openerp
    chown openerp:openerp /var/run/openerp
}

install_openerp(){
    cd $BAHMNI_ERP
    tar -xvzf openerp-7.0-20130301-002301.tar.gz
    cd openerp-7.0-20130301-002301
    sudo python setup.py -q install
    cp openerp-server $BAHMNI_ERP
    cp install/openerp-server.conf $BAHMNI_ERP/etc
    cp -r $BAHMNI_ERP/bahmni-addons/* /usr/lib/python2.6/site-packages/openerp-7.0_20130301_002301-py2.6.egg/openerp/addons
    rm -rf $BAHMNI_ERP/openerp-7.0-20130301-002301
    rm -rf $BAHMNI_ERP/openerp-7.0-20130301-002301.tar.gz
}

link_directories(){
    ln -s $BAHMNI_ERP/etc /etc/openerp
    chown -R openerp:openerp /etc/openerp
}

manage_config(){
    chkconfig openerp on
    cp -f $BAHMNI_ERP/etc/openerp /etc/init.d/openerp
}

manage_permissions
install_openerp
link_directories
manage_config
