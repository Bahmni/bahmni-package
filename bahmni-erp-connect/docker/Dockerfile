FROM openjdk:8-alpine

ENV SERVER_PORT=8053
ENV BASE_DIR=/var/run/bahmni-erp-connect
ENV CONTEXT_PATH=/bahmni-erp-connect
ENV WAR_DIRECTORY=/var/run/bahmni-erp-connect/bahmni-erp-connect
ENV SERVER_OPTS="-Xms512m -Xmx1024m -XX:PermSize=256m -XX:MaxPermSize=512m"
ENV DEBUG_OPTS="-agentlib:jdwp=transport=dt_socket,address=8002,server=y,suspend=n"

RUN apk add gettext

COPY docker/bahmni-core.jar /opt/bahmni-erp-connect/lib/bahmni-erp-connect.jar
COPY resources/openerp-atomfeed-service.war /etc/bahmni-erp-connect/openerp-atomfeed-service.war

RUN mkdir -p ${WAR_DIRECTORY}
RUN cd ${WAR_DIRECTORY} && jar xvf /etc/bahmni-erp-connect/openerp-atomfeed-service.war

COPY resources/log4j.xml ${WAR_DIRECTORY}/WEB-INF/classes/
COPY docker/erp-atomfeed.properties.template /opt/bahmni-erp-connect/etc/erp-atomfeed.properties.template
COPY docker/scripts/run-liquibase.sh /opt/bahmni-erp-connect/etc/run-liquibase.sh
RUN chmod +x /opt/bahmni-erp-connect/etc/run-liquibase.sh

COPY docker/scripts/start.sh start.sh
RUN chmod +x start.sh
CMD [ "./start.sh" ]
