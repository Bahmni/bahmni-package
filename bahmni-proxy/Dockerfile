FROM httpd:2.4-alpine

COPY resources/bahmni-proxy.conf /usr/local/apache2/conf/
RUN echo "Include conf/bahmni-proxy.conf" >> /usr/local/apache2/conf/httpd.conf
COPY resources/index.html /usr/local/apache2/htdocs/index.html
COPY resources/systemdate.sh /usr/local/apache2/cgi-bin/systemdate
