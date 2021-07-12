#!/bin/bash

if [ -f /etc/bahmni-installer/bahmni.conf ]; then
. /etc/bahmni-installer/bahmni.conf
fi

dcm4chee_path=/var/lib/bahmni/dcm4chee-2.18.1-psql
ln -s /opt/dcm4chee/etc  /etc/dcm4chee

if [ "${IS_PASSIVE:-0}" -ne "1" ]; then
    sudo /opt/dcm4chee/etc/initDCM4CHEE-DB.sh
fi
sudo $dcm4chee_path/bin/install_jboss.sh /usr/share/jboss-4.2.3.GA

rm -rf $dcm4chee_path/server/default/deploy/jboss-web.deployer/server.xml
rm -rf $dcm4chee_path/server/default/conf/jboss-service.xml
rm -rf $dcm4chee_path/server/default/deploy/pacs-postgres-ds.xml
ln -s /opt/dcm4chee/etc/server.xml $dcm4chee_path/server/default/deploy/jboss-web.deployer/
ln -s /opt/dcm4chee/etc/jboss-service.xml $dcm4chee_path/server/default/conf/
ln -s /opt/dcm4chee/etc/orm2dcm_bahmni.xsl $dcm4chee_path/server/default/conf/dcm4chee-hl7/
ln -s /opt/dcm4chee/etc/pacs-postgres-ds.xml $dcm4chee_path/server/default/deploy/
cp -f /opt/dcm4chee/etc/inspectMBean.jsp $dcm4chee_path/server/default/deploy/jmx-console.war/

#Oviyam2 steps
cp -R /opt/dcm4chee/etc/oviyam2.war $dcm4chee_path/server/default/deploy/
cp -f /opt/dcm4chee/etc/oviyam2-web.xml $dcm4chee_path/server/default/deploy/oviyam2.war/WEB-INF/web.xml

mkdir -p $dcm4chee_path/server/default/work/jboss.web/localhost

ln -s /opt/dcm4chee/etc/oviyam2-7-config.xml $dcm4chee_path/server/default/work/jboss.web/localhost/
chmod 644 $dcm4chee_path/server/default/work/jboss.web/localhost/oviyam2-7-config.xml

ln -s /opt/dcm4chee/bin/dcm4chee /etc/init.d/dcm4chee
chown -R bahmni:bahmni /etc/init.d/dcm4chee
chown -R bahmni:bahmni /var/lib/bahmni/dcm4chee-2.18.1-psql

pacs_images_dir=/home/bahmni/pacs_images
mkdir -p ${pacs_images_dir}/archive
chown -R bahmni:bahmni ${pacs_images_dir}
ln -s ${pacs_images_dir}/archive ${dcm4chee_path}/server/default/archive

setupConfFiles() {
    rm -f /etc/httpd/conf.d/dcm4chee_ssl.conf
    cp -f /opt/dcm4chee/etc/dcm4chee_ssl.conf /etc/httpd/conf.d/dcm4chee_ssl.conf
}

setupConfFiles
