#!/bin/bash

if [ -L /etc/httpd/conf/httpd.conf ] ; then
    if [ ! -e /etc/httpd/conf/httpd.conf ] ; then
        #broken link
        unlink /etc/httpd/conf/httpd.conf
        cp /etc/httpd/conf/default_httpd.conf.bak /etc/httpd/conf/httpd.conf
    fi
fi

if [ -L /etc/httpd/conf.d/ssl.conf ] ; then
    if [ ! -e /etc/httpd/conf.d/ssl.conf ] ; then
        #broken link
        unlink /etc/httpd/conf.d/ssl.conf
        cp /etc/httpd/conf.d/default_ssl.conf.bak /etc/httpd/conf.d/ssl.conf
    fi
fi
