#!/bin/bash

wget https://dev.mysql.com/get/mysql-apt-config_0.8.9-1_all.deb >> $LOG_FILE 2>&1

debconf-set-selections <<< "mysql-apt-config mysql-apt-config/unsupported-platform select abort"
debconf-set-selections <<< "mysql-apt-config mysql-apt-config/repo-codename select stretch"
debconf-set-selections <<< "mysql-apt-config mysql-apt-config/select-tools select"
debconf-set-selections <<< "mysql-apt-config mysql-apt-config/repo-distro select debian"
debconf-set-selections <<< "mysql-apt-config mysql-apt-config/select-server select mysql-5.7"
debconf-set-selections <<< "mysql-apt-config mysql-apt-config/select-product select Apply"
debconf-set-selections <<< "mysql-server mysql-server/root-pass password $DB_ROOT_PASSWD"
debconf-set-selections <<< "mysql-server mysql-server/re-root-pass password $DB_ROOT_PASSWD"

export DEBIAN_FRONTEND=noninteractive

dpkg -i mysql-apt-config_0.8.9-1_all.deb >> $LOG_FILE 2>&1
rm mysql-apt-config_0.8.9-1_all.deb
apt update >> $LOG_FILE 2>&1
apt install -y mysql-server >> $LOG_FILE 2>&1

# Configuration
sed -i 's/bind-address.*/bind-address\t= 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

service mysql restart >> $LOG_FILE 2>&1

mysql -u root -p$DB_ROOT_PASSWD -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$DB_ROOT_PASSWD'); ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$DB_ROOT_PASSWD'; FLUSH PRIVILEGES;" >> $LOG_FILE 2>&1
mysql -u root -p$DB_ROOT_PASSWD -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWD'; ALTER USER '$DB_USER'@'%' IDENTIFIED WITH mysql_native_password BY '$DB_PASSWD'; GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;" >> $LOG_FILE 2>&1

service mysql restart >> $LOG_FILE 2>&1