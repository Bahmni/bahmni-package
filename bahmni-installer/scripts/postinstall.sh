mkdir -p /etc/bahmni-installer
mkdir -p /etc/bahmni-installer/deployment-artifacts/modules

rm -f /usr/bin/bahmni
chown -R bahmni:bahmni /opt/bahmni-installer
rm -f /etc/bahmni-installer/rpm_versions.yml
ln -s /opt/bahmni-installer/etc/rpm_versions.yml /etc/bahmni-installer/rpm_versions.yml

mkdir -p /var/log/bahmni-installer
chown bahmni:bahmni /var/log/bahmni-installer
chmod 777 /var/log/bahmni-installer
touch /var/log/bahmni-installer/bahmni-installer.log
chmod 666 /var/log/bahmni-installer/bahmni-installer.log

rm -f /etc/bahmni-installer/local
ln -s /opt/bahmni-installer/bahmni-playbooks/local /etc/bahmni-installer/local
chmod -x /etc/bahmni-installer/local

pip install --upgrade setuptools

echo "-------------Installing bahmni command line tool--------------"
cd /opt/bahmni-installer/bahmni-command-line-tool && python setup.py install
