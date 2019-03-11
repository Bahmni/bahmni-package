#!/bin/bash

export BAHMNI_ERP=/opt/bahmni-erp
ODOO_DB_SERVER=localhost

if [ -f /etc/bahmni-installer/bahmni.conf ]; then
. /etc/bahmni-installer/bahmni.conf
fi

manage_permissions(){
    chown -R odoo:odoo $BAHMNI_ERP
    mkdir -p /var/log/odoo
    mkdir -p /var/run/odoo
    chown odoo:odoo /var/log/odoo
    chown odoo:odoo /var/run/odoo
}

install_openerp(){
    cd $BAHMNI_ERP
    unzip 10.0.zip
    cd odoo-10.0
    sudo python setup.py -q install
    cp -r addons/* $BAHMNI_ERP/bahmni-addons
    cp odoo-bin $BAHMNI_ERP
    cp debian/odoo.conf $BAHMNI_ERP/etc
    sed -i 's+addons_path = /usr/lib/python2.7/dist-packages/odoo/addons+addons_path = /usr/lib/python2.7/site-packages/odoo-10.0-py2.7.egg/odoo/addons+g' $BAHMNI_ERP/etc/odoo.conf
    cp -r $BAHMNI_ERP/bahmni-addons/* /usr/lib/python2.7/site-packages/odoo-10.0-py2.7.egg/odoo/addons
    cd $BAHMNI_ERP
    rm -rf $BAHMNI_ERP/odoo-10.0
    rm -rf $BAHMNI_ERP/10.0.zip
}

initDB(){
    RESULT_USER=`psql -U postgres -h$ODOO_DB_SERVER -tAc "SELECT count(*) FROM pg_roles WHERE rolname='odoo'"`
    RESULT_DB=`psql -U postgres -h$ODOO_DB_SERVER -tAc "SELECT count(*) from pg_catalog.pg_database where datname='odoo'"`
    if [ "$RESULT_USER" == "0" ]; then
        echo "creating postgres user - odoo with roles CREATEDB,NOCREATEROLE,SUPERUSER,REPLICATION"
        createuser -Upostgres  -h$ODOO_DB_SERVER -d -R -s --replication odoo;
    fi

    if [ "$RESULT_DB" == "0" ]; then
        echo "Restoring base dump of odoo"
        createdb -Uodoo -h$ODOO_DB_SERVER odoo;

    fi
    sudo -u odoo ./odoo-bin -d odoo
}

link_directories(){
    ln -s $BAHMNI_ERP/etc /etc/odoo
    chown -R odoo:odoo /etc/odoo
}

manage_config(){
    ln -s $BAHMNI_ERP/bin/odoo /etc/rc.d/init.d/odoo
    chown odoo:odoo /etc/rc.d/init.d/odoo
}

install_openerp
if [ "${IS_PASSIVE:-0}" -ne "1" ]; then
    initDB
fi
link_directories
manage_config
manage_permissions
chkconfig odoo on
