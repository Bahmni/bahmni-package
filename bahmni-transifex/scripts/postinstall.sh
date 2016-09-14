#!/bin/bash

TRANSIFEX_PATH="/opt/bahmni-transifex/transifex" 

echo "running the postinstall script"

cp -rf $TRANSIFEX_PATH/* /var/www/bahmniapps/i18n/.

