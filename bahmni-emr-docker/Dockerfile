FROM centos:centos8

RUN dnf install java-1.8.0-openjdk -y
RUN dnf install unzip -y
RUN dnf install sudo -y

ARG OPT_OPENMRS=/opt/openmrs
ARG OPT_OPENMRS_ETC=/opt/openmrs/etc/
ARG OPT_OPENMRS_LIB=/opt/openmrs/lib/


# copy pasta 🍝 of scripts, configuration and artifacts
COPY ./scripts/ /bahmni-emr/scripts/

# 🏃 run preinstall scripts
RUN chmod 0744 /bahmni-emr/scripts/preinstall.sh
RUN ./bahmni-emr/scripts/preinstall.sh

RUN mkdir /var/log/openmrs/
RUN mkdir /var/run/openmrs/

# 🎬 make jar ready for execution
COPY ./build/libs/openmrs.jar ${OPT_OPENMRS_LIB}/
RUN chmod 0744 ${OPT_OPENMRS_LIB}/openmrs.jar

# copy pasta 🍝 of resources, configuration
COPY ./resources/ ${OPT_OPENMRS_ETC}
COPY ./scripts/rpm/ ${OPT_OPENMRS}/bin
COPY ./build/resources/main/openmrs.war ${OPT_OPENMRS}
COPY ./resources/bahmnicore.properties ${OPT_OPENMRS}
COPY ./resources/placeholder ${OPT_OPENMRS}/openmrs/
COPY ./resources/placeholder ${OPT_OPENMRS}/log/
COPY ./scripts/openmrs.service /usr/lib/systemd/system/

# 🎬 make conf ready for execution
RUN chmod 0744 /${OPT_OPENMRS_ETC}/openmrs.conf
RUN ./${OPT_OPENMRS_ETC}/openmrs.conf
RUN chmod 0744 /${OPT_OPENMRS_ETC}/bahmni-emr.conf
RUN ./${OPT_OPENMRS_ETC}/bahmni-emr.conf

RUN export OPENMRS_SERVER_USER=bahmni
RUN export OPENMRS_SERVER_RUN=/opt/openmrs/bin/start.sh
RUN export OPENMRS_SERVER_DEBUG=/opt/openmrs/bin/debug.sh
RUN export CUR_USER=`/usr/bin/whoami`
RUN export OPENMRS_LIB_CACHE=/tmp/*.openmrs-lib-cache

RUN export SERVER_PORT=8050
RUN export BASE_DIR=/var/run/openmrs
RUN export CONTEXT_PATH=/openmrs
RUN export WAR_DIRECTORY=/var/run/openmrs/openmrs
RUN export OPENMRS_RUNTIME_PROPERTIES_FILE=/etc/openmrs/openmrs-runtime.properties
RUN export MODULE_REPO=/opt/openmrs/modules
RUN export SERVER_OPTS="-Xms512m -Xmx1024m -XX:PermSize=256m -XX:MaxPermSize=512m"
RUN export DEBUG_OPTS="-agentlib:jdwp=transport=dt_socket,address=8000,server=y,suspend=n"



RUN export OPENMRS_SERVER_USER=bahmni
RUN export OPENMRS_DB_SERVER=localhost
RUN export OPENMRS_DB_PASSWORD=password
RUN export OPENMRS_DB_USERNAME=openmrs-user
RUN export CHANGE_LOG_TABLE="-Dliquibase.databaseChangeLogTableName=liquibasechangelog -Dliquibase.databaseChangeLogLockTableName=liquibasechangeloglock"
RUN export LIQUIBASE_JAR="/opt/openmrs/openmrs/WEB-INF/lib/liquibase-core-2.0.5.jar"
RUN export DRIVER="com.mysql.jdbc.Driver"
RUN export COMMON_CLASSPATH="/opt/openmrs/openmrs.war"
RUN export SNAPSHOTS_DIR=/opt/openmrs/etc/migrations/files/snapshots
RUN export MODULE_REPO=/opt/openmrs/modules
RUN export UPLOADS_DIR=/home/bahmni/
RUN export PATIENT_IMAGES_DIR=/home/bahmni/patient_images
RUN export DOCUMENT_IMAGES_DIR=/home/bahmni/document_images
RUN export UPLOADED_FILES_DIR=/home/bahmni/uploaded-files/mrs
RUN export UPLOADED_RESULTS_DIR=/home/bahmni/uploaded_results

RUN ln -s /opt/openmrs/run /var/run/openmrs
RUN ln -s /opt/openmrs/openmrs /var/run/openmrs/openmrs
#RUN ln -s /opt/openmrs/log /var/log/openmrs

RUN mkdir /home/bahmni/.OpenMRS
RUN chown bahmni:bahmni /home/bahmni/.OpenMRS
RUN ln -sf /opt/openmrs/etc/openmrs-runtime.properties /home/bahmni/.OpenMRS/openmrs-runtime.properties
RUN ln -s $MODULE_REPO /home/bahmni/.OpenMRS/modules
RUN chown -R bahmni:bahmni /home/bahmni/.OpenMRS

# 🏃 run openmrs scripts
RUN chmod 0744 /bahmni-emr/scripts/rpm/openmrs
RUN chmod 0744 /bahmni-emr/scripts/rpm/start.sh
RUN chmod 0744 /usr/lib/systemd/system/openmrs.service

# 🔍 run openmrs postinstall scripts
RUN ln -s /opt/openmrs/etc /etc/openmrs
RUN ln -s /opt/openmrs/log /var/log/openmrs
RUN chmod 0744 /bahmni-emr/scripts/postinstall.sh
RUN (cd /opt/openmrs/openmrs && unzip ../openmrs.war)
#RUN chkconfig --add openmrs

RUN mkdir -p /opt/openmrs/openmrs/WEB-INF/classes/ && cp /opt/openmrs/etc/log4j.xml /opt/openmrs/openmrs/WEB-INF/classes/
RUN cp -f /opt/openmrs/etc/web.xml /opt/openmrs/openmrs/WEB-INF/

# permissions
RUN chown -R bahmni:bahmni /opt/openmrs
RUN chown -R bahmni:bahmni /var/log/openmrs
RUN chown -R bahmni:bahmni /etc/openmrs


CMD [-d /home/bahmni/.OpenMRS]|| mkdir /home/bahmni/.OpenMRS
RUN chown -R bahmni:bahmni /home/bahmni/.OpenMRS

RUN ln -s /opt/openmrs/bahmnicore.properties /home/bahmni/.OpenMRS/bahmnicore.properties
RUN mkdir -p /home/bahmni/patient_images
RUN mkdir -p /home/bahmni/document_images
RUN mkdir -p /home/bahmni/uploaded-files/mrs
RUN mkdir -p /home/bahmni/uploaded_results

RUN cp -f /opt/openmrs/etc/blank-user.png /home/bahmni/patient_images/blank-user.png

RUN chown -R bahmni:bahmni /opt/openmrs
RUN chmod -R 755 /opt/openmrs
RUN chown -R bahmni:bahmni /home/bahmni/
RUN chmod 755 /home/bahmni/;
RUN chmod -R 755 /home/bahmni/patient_images
RUN chmod -R 755 /home/bahmni/document_images
RUN chmod -R 755 /home/bahmni/uploaded-files/mrs
RUN chmod -R 755 /home/bahmni/uploaded_results


#CMD ./bahmni-emr/scripts/postinstall.sh

ENTRYPOINT ./bahmni-emr/scripts/rpm/openmrs start
