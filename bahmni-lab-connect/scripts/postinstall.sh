
link_dirs(){
    ln -s /opt/bahmni-lab-connect/modules/* /opt/openmrs/modules
    chown -R bahmni:bahmni /opt/bahmni-lab-connect/modules/
}

link_dirs