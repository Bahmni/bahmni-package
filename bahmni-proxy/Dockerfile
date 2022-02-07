FROM httpd:2.4-alpine

RUN mkdir /usr/local/apache2/htdocs/client_side_logging
COPY resources/bahmni-proxy.conf /usr/local/apache2/conf/
RUN echo "Include conf/bahmni-proxy.conf" >> /usr/local/apache2/conf/httpd.conf
COPY resources/index.html /usr/local/apache2/htdocs/index.html
COPY resources/systemdate.sh /usr/local/apache2/cgi-bin/systemdate
COPY resources/__init__.py \
	 resources/client_side_logging.py \
	 resources/client_side_logging.wsgi \
	 resources/logging.yml \
	 resources/RotatingLogger.py \
	 /usr/local/apache2/htdocs/client_side_logging
	
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

RUN mkdir -p /var/log/client-side-logs/ &&\
	touch /var/log/client-side-logs/client-side.log &&\
	chmod 777 /var/log/client-side-logs/client-side.log &&\
	ln -s /usr/local/apache2/htdocs/client_side_logging /usr/lib/python3*/site-packages/ 

RUN pip install Flask pyyaml==5.4.1 mod_wsgi
