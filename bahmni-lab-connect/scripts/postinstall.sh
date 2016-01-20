
link_dirs(){
    rm -f /opt/openmrs/modules/openelis-atomfeed-client*.omod
    ln -s /opt/bahmni-lab-connect/modules/* /opt/openmrs/modules
    chown -R bahmni:bahmni /opt/bahmni-lab-connect/modules/
    chown -R bahmni:bahmni /opt/bahmni-lab-connect/lib/
    chown -R bahmni:bahmni /opt/openmrs/modules/openelis-atomfeed-client*.omod
    chmod 755 /opt/openmrs/modules/openelis-atomfeed-client*.omod
}

run_migrations(){
    echo "Running openelis-atomfeed-client and atomfeed-client migrations"
    /opt/bahmni-lab-connect/run-liquibase.sh
}

link_dirs
run_migrations