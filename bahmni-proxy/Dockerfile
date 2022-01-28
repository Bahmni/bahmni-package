FROM httpd:2.4-alpine

COPY resources/bahmni-proxy.conf /usr/local/apache2/conf/
RUN echo "Include conf/bahmni-proxy.conf" >> /usr/local/apache2/conf/httpd.conf
COPY resources/index.html /usr/local/apache2/htdocs/index.html
COPY resources/systemdate.sh /usr/local/apache2/cgi-bin/systemdate
COPY resources/bahmni-logo.png /usr/local/apache2/htdocs/bahmni-logo.png
COPY resources/favicon.png /usr/local/apache2/htdocs/favicon.png
COPY resources/maintenance.html /usr/local/apache2/htdocs/maintenance.html
COPY resources/src.jpeg /usr/local/apache2/htdocs/src.jpeg
RUN mkdir /var/cache/mod_proxy
RUN apk add --update openssl && \
    rm -rf /var/cache/apk/*
RUN cd /etc/ &&\
    mkdir tls &&\
    cd tls &&\
    openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=localhost" -keyout key.pem  -out cert.pem

