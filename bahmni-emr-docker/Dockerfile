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

RUN dnf install java-1.8.0-openjdk -y
RUN dnf install unzip -y

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

COPY ./resources/openmrs.conf ${OPT_OPENMRS_ETC}
COPY ./resources/openmrs-runtime.properties ${OPT_OPENMRS_ETC}
COPY ./resources/bahmni-emr.conf ${OPT_OPENMRS_ETC}
COPY ./resources/bahmnicore.properties ${OPT_OPENMRS}
COPY ./resources/emr_ssl.conf ${OPT_OPENMRS_ETC}
COPY ./resources/log4j.xml ${OPT_OPENMRS_ETC}
COPY ./resources/web.xml ${OPT_OPENMRS_ETC}
COPY ./resources/blank-user.png ${OPT_OPENMRS_ETC}
COPY ./build/resources/main/openmrs.war ${OPT_OPENMRS}

# 🎬 make jar executable or ready for it
COPY ./build/libs/openmrs.jar ${OPT_OPENMRS_LIB}/
RUN chmod 0744 ${OPT_OPENMRS_LIB}/openmrs.jar

RUN chmod 0744 /bahmni-emr/scripts/postinstall.sh
RUN ./bahmni-emr/scripts/postinstall.sh

RUN . /etc/openmrs/openmrs.conf
# 🏃 run openmrs scripts
RUN chmod 0744 /bahmni-emr/scripts/rpm/openmrs
RUN ./bahmni-emr/scripts/rpm/openmrs 1

RUN chmod 0744 /bahmni-emr/scripts/rpm/start.sh
#ENTRYPOINT ./bahmni-emr/scripts/rpm/start.sh
