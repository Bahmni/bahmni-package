#!/bin/bash

export BAHMNI_ERP=/opt/bahmni-erp
OPENERP_DB_SERVER=localhost

if [ -f /etc/bahmni-installer/bahmni.conf ]; then
. /etc/bahmni-installer/bahmni.conf
fi

manage_permissions(){
    adduser openerp
    chown -R openerp:openerp $BAHMNI_ERP
    mkdir -p /var/log/openerp
    mkdir -p /var/run/openerp
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

initDB(){
    RESULT_USER=`psql -U postgres -h$OPENERP_DB_SERVER -tAc "SELECT count(*) FROM pg_roles WHERE rolname='openerp'"`
    RESULT_DB=`psql -U postgres -h$OPENERP_DB_SERVER -tAc "SELECT count(*) from pg_catalog.pg_database where datname='openerp'"`
    if [ "$RESULT_USER" == "0" ]; then
        echo "creating postgres user - openerp with roles CREATEDB,NOCREATEROLE,SUPERUSER,REPLICATION"
        createuser -Upostgres  -h$OPENERP_DB_SERVER -d -R -s --replication openerp;
    fi

    if [ "$RESULT_DB" == "0" ]; then
        echo "Restoring base dump of openerp"
        createdb -Uopenerp -h$OPENERP_DB_SERVER openerp;
        psql -Uopenerp -h$OPENERP_DB_SERVER openerp < /opt/bahmni-erp/db-dump/openerp_base_dump.sql
    fi
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
if [ "${IS_PASSIVE:-0}" -ne "1" ]; then
    initDB
fi
link_directories
manage_config

