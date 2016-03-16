#create openerp user and group if doesn't exist
[ $(getent group openerp) ]|| groupadd openerp
[ $(getent passwd openerp) ] || adduser -g openerp openerp