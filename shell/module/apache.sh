#!/bin/bash

# Apache
apt install -y apache2 libapache2-mod-fcgid >> $LOG_FILE 2>&1
a2enmod rewrite expires headers proxy proxy_http proxy_fcgi actions fastcgi alias ssl >> $LOG_FILE 2>&1

# Activate vhost
a2dissite 000-default >> $LOG_FILE 2>&1

chmod -R a+rX /var/log/apache2
sed -i 's/640/666/' /etc/logrotate.d/apache2

echo 'Listen 80
      Listen 443
' >  /etc/apache2/ports.conf

# sed -i 's/APACHE_RUN_USER=www-data/APACHE_RUN_USER='${USER}'/' /etc/apache2/envvars
# sed -i 's/APACHE_RUN_GROUP=www-data/APACHE_RUN_GROUP='${GROUP}'/' /etc/apache2/envvars

# sed -i 's/User ${APACHE_RUN_USER}/User '${USER}'/' /etc/apache2/apache2.conf
# sed -i 's/Group ${APACHE_RUN_GROUP}/Group '${GROUP}'/' /etc/apache2/apache2.conf

cat $CONFIG_PATH/apache/vhost.conf > /etc/apache2/sites-available/${APP_DOMAIN}.conf
a2ensite ${APP_DOMAIN}.conf >> $LOG_FILE 2>&1

service apache2 restart >> $LOG_FILE 2>&1
