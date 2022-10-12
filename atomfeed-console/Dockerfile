FROM amazoncorretto:8
COPY resources/application.yml.template .
COPY resources/start.sh .
COPY resources/*.jar .
RUN yum install -y gettext
EXPOSE 9080
RUN chmod +x start.sh 
ENTRYPOINT ["./start.sh"]