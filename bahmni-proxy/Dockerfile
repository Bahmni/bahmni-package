FROM httpd:2.4-alpine

COPY resources/bahmni-proxy.conf /usr/local/apache2/conf/
RUN echo "Include conf/bahmni-proxy.conf" >> /usr/local/apache2/conf/httpd.conf
COPY resources/index.html /usr/local/apache2/htdocs/index.html
COPY resources/systemdate.sh /usr/local/apache2/cgi-bin/systemdate
RUN apk add --update openssl && \
    rm -rf /var/cache/apk/*
RUN cd /etc/ &&\
    mkdir tls &&\
    cd tls &&\
    openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=localhost" -keyout key.pem  -out cert.pem
