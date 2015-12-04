
link_dirs(){
    mkdir -p /home/bahmni/.OpenMRS/modules
    ln -s /opt/bahmni-lab-connect/modules/* /opt/openmrs/modules
    chown -R bahmni:bahmni /opt/bahmni-lab-connect/modules/
}

link_dirs