ln -s /opt/bahmni-offline/ /var/www/bahmni-connect-apps


chown -R bahmni:bahmni /opt/bahmni-offline

chmod 755 /opt/bahmni-offline

chown -R bahmni:bahmni /var/www/bahmni-connect-apps

chmod -R 755 /var/www/bahmni-connect-apps
