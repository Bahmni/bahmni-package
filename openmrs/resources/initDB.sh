#!/bin/sh
set -e -x

RESULT=`mysql -uroot -ppassword --skip-column-names -e "SHOW DATABASES LIKE 'openmrs'"`
if [ "$RESULT" != "openmrs" ]; then
    mysql -uroot -ppassword < scripts/mrs_base.sql
fi
