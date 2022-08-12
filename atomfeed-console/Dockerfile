FROM openjdk:8-alpine
COPY resources/application.yml.template .
COPY resources/start.sh .
COPY resources/*.jar .
RUN apk add gettext
EXPOSE 9080
RUN chmod +x start.sh 
ENTRYPOINT ["./start.sh"]