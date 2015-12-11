#create bahmni user and group if doesn't exist
[ $(getent group bahmni) ]|| groupadd bahmni
[ $(getent passwd bahmni) ] || useradd -g bahmni bahmni
