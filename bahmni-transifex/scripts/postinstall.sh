#!/bin/bash

TRANSIFEX_PATH="/opt/bahmni-transifex/transifex" 

echo "running the postinstall script"


#This is a temporary fix.  Will issue a Pull Request for migration of global_property <locale.allowed.list> for bahmni-core

mv $TRANSIFEX_PATH/admin/locale_pt_BR.json $TRANSIFEX_PATH/admin/locale_pt.json
mv $TRANSIFEX_PATH/adt/locale_pt_BR.json $TRANSIFEX_PATH/adt/locale_pt.json 
mv $TRANSIFEX_PATH/clinical/locale_pt_BR.json $TRANSIFEX_PATH/clinical/locale_pt.json
mv $TRANSIFEX_PATH/home/locale_pt_BR.json $TRANSIFEX_PATH/home/locale_pt.json
mv $TRANSIFEX_PATH/orders/locale_pt_BR.json $TRANSIFEX_PATH/orders/locale_pt.json
mv $TRANSIFEX_PATH/registration/locale_pt_BR.json $TRANSIFEX_PATH/registration/locale_pt.json
mv $TRANSIFEX_PATH/reports/locale_pt_BR.json $TRANSIFEX_PATH/reports/locale_pt.json

cp -rf $TRANSIFEX_PATH/* /var/www/bahmniapps/i18n/.

