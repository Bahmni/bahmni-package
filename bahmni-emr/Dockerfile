# TODO BDI-2 decide which Linux to use
#FROM alpine
##
##RUN apk update && \
##    apk upgrade
#RUN apk add openjdk8-jre

# TODO BDI-2 decide which Linux to use
#FROM ubuntu:20.04
#RUN apt-get update
#RUN apt-get install openjdk-8-jdk -y

FROM centos:centos8

# TODO BDI-2 remove installation of mysql, it is used to test connectivity to the database server
RUN yum install mysql -y
RUN yum install sudo -y
RUN yum install unzip -y
RUN yum install java-1.8.0-openjdk -y

ARG OPT_OPENMRS=/opt/openmrs

COPY ./scripts/ /bahmni-emr/scripts/
RUN . /bahmni-emr/scripts/preinstall.sh

COPY ./build/libs/openmrs.jar ${OPT_OPENMRS}/lib/
RUN chmod 0644 ${OPT_OPENMRS}/lib/openmrs.jar

COPY ./resources/initDB.sh ${OPT_OPENMRS}/etc/
RUN chmod 0644 ${OPT_OPENMRS}/etc/initDB.sh

COPY ./scripts/rpm/* ${OPT_OPENMRS}/bin/
RUN chmod 0744 ${OPT_OPENMRS}/bin/*

COPY ./scripts/openmrs.service /bin/
RUN chmod 0744 /bin/openmrs.service

COPY ./resources/placeholder ${OPT_OPENMRS}/log/
COPY ./resources/placeholder ${OPT_OPENMRS}/openmrs/
COPY ./resources/placeholder ${OPT_OPENMRS}/run/

COPY ./build/resources/main/openmrs.war ${OPT_OPENMRS}
RUN chmod 0644 ${OPT_OPENMRS}/openmrs.war

COPY ./resources/initDB.sh ${OPT_OPENMRS}/openmrs/scripts/
RUN chmod 0744 ${OPT_OPENMRS}/openmrs/scripts/initDB.sh

COPY ./resources/openmrs_demo_dump.sql ${OPT_OPENMRS}/openmrs/scripts/
RUN chmod 0644 ${OPT_OPENMRS}/openmrs/scripts/openmrs_demo_dump.sql

COPY ./resources/openmrs_clean_dump.sql ${OPT_OPENMRS}/openmrs/scripts/
RUN chmod 0644 ${OPT_OPENMRS}/openmrs/scripts/openmrs_clean_dump.sql

# TODO BDI-2 copy omod files into folder for bundled modules

COPY ./resources/bahmni-emr.conf ${OPT_OPENMRS}/etc/
RUN chmod 0644 ${OPT_OPENMRS}/etc/bahmni-emr.conf

# TODO BDI-2 this differs from the gradle build as we are copying ALL resource files
COPY ./resources/* ${OPT_OPENMRS}/etc/
RUN chmod 0644 ${OPT_OPENMRS}/etc/*
RUN chmod 0744 ${OPT_OPENMRS}/etc/run-liquibase.sh
RUN chmod 0755 ${OPT_OPENMRS}/etc/blank-user.png
RUN chmod 0755 ${OPT_OPENMRS}/etc/emr_ssl.conf

RUN . /bahmni-emr/scripts/postinstall.sh

#ENTRYPOINT ["/opt/openmrs/bin/openmrs", "debug"]