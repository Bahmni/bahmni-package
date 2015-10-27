#!/bin/sh
set -e -x

RESULT=`mysql -uroot -ppassword --skip-column-names -e "SHOW DATABASES LIKE 'openmrs'"`
if [ "$RESULT" != "openmrs" ]; then
    echo "openmrs database not found... Restoring a base dump"
    mysql -uroot -ppassword < scripts/mrs_base.sql
fi
