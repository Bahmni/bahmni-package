FROM openmrs/openmrs-distro-platform:2.1.4

COPY build/openmrs-modules/*.omod /usr/local/tomcat/.OpenMRS/modules/
COPY docker/templates/bahmnicore.properties.template /etc/bahmni-emr/templates/
COPY resources/atomfeed-client-*.jar /etc/bahmni-lab-connect/atomfeed-client.jar
COPY resources/liquibase-core-*.jar /etc/bahmni-lab-connect/liquibase-core.jar

# Used by envsubst command for replacing environment values at runtime
RUN apt-get update && apt-get install gettext-base

COPY docker/scripts/bahmni_startup.sh /usr/local/tomcat/
RUN chmod +x /usr/local/tomcat/bahmni_startup.sh

CMD ["./bahmni_startup.sh"]
