#!/bin/bash

export BAHMNI_ERP=/opt/bahmni-erp
ODOO_DB_SERVER=localhost

if [ -f /etc/bahmni-installer/bahmni.conf ]; then
. /etc/bahmni-installer/bahmni.conf
fi

install_wkhtml(){
    wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
    unxz wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
    tar -xvf wkhtmltox-0.12.4_linux-generic-amd64.tar
    cp wkhtmltox/bin/wkhtmltopdf /usr/bin/wkhtmltopdf
    rm wkhtmltox-0.12.4_linux-generic-amd64.tar
}


manage_permissions(){
    chown -R odoo:odoo $BAHMNI_ERP
    mkdir -p /var/log/odoo
    mkdir -p /var/run/odoo
    chown odoo:odoo /var/log/odoo
    chown odoo:odoo /var/run/odoo
}

install_openerp(){
    cd $BAHMNI_ERP
    unzip odoo_10.0.20190619.zip
    mv odoo-10.0.post20190619/* .
    sudo pip uninstall beautifulsoup4
    sudo pip install beautifulsoup4==v4.9.3
    sudo pip uninstall xlsxwriter
    sudo pip install xlsxwriter==v2.0.0 
    sudo pip install soupsieve
    sudo python setup.py -q install
    # cp debian/odoo.conf $BAHMNI_ERP/etc
    mkdir bahmni-addons
    sudo sed -i 's+addons_path = /usr/lib/python2.7/dist-packages/odoo/addons+addons_path = /opt/bahmni-erp/bahmni-addons,/opt/bahmni-erp/odoo/addons,/usr/lib/python2.7/site-packages+' $BAHMNI_ERP/odoo.conf
    sudo echo 'logfile = /var/log/odoo/odoo.log' >> /opt/bahmni-erp/odoo.conf
    sudo echo 'log_level = error' >> /opt/bahmni-erp/odoo.conf
    cd $BAHMNI_ERP
    rm -rf $BAHMNI_ERP/odoo_10.0.20190619.zip
    rm -rf $BAHMNI_ERP/odoo-10.0.20190619
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

         if [ "${IMPLEMENTATION_NAME:-default}" = "default" ]; then
            psql -Uodoo -h$ODOO_DB_SERVER odoo < /opt/bahmni-erp/db-dump/odoo_demo_dump.sql
        else
            psql -Uodoo -h$ODOO_DB_SERVER odoo < /opt/bahmni-erp/db-dump/odoo_clean_dump.sql
        fi

    fi
}

link_directories(){
    sudo cp $BAHMNI_ERP/odoo.conf /etc/odoo.conf
    sudo chown -R odoo:odoo /etc/odoo.conf
}

manage_config(){
    sudo ln -s $BAHMNI_ERP/bin/odoo /etc/rc.d/init.d/odoo
    sudo chown odoo:odoo /etc/rc.d/init.d/odoo
}

install_wkhtml
install_openerp
if [ "${IS_PASSIVE:-0}" -ne "1" ]; then
    initDB
fi
link_directories
manage_config
manage_permissions
chkconfig odoo on