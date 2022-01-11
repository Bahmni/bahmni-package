FROM httpd:2.4-alpine

COPY resources/bahmni-proxy.conf /usr/local/apache2/conf/
RUN echo "Include conf/bahmni-proxy.conf" >> /usr/local/apache2/conf/httpd.conf
COPY resources/index.html /usr/local/apache2/htdocs/index.html
COPY resources/systemdate.sh /usr/local/apache2/cgi-bin/systemdate
RUN mkdir /usr/local/apache2/htdocs/client_side_logging
RUN apk add --update openssl && \
    rm -rf /var/cache/apk/*
RUN cd /etc/ &&\
    mkdir tls &&\
    cd tls &&\
    openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=localhost" -keyout key.pem  -out cert.pem
RUN apk add --no-cache --virtual .build-deps \
		apr-dev \
		apr-util-dev \
		gcc \
        libc-dev \
		apache2-dev \
		apache2-utils \
		py-pip \
		tar \
        python3-dev 
	
RUN pip install mod_wsgi

