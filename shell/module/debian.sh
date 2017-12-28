#!/bin/bash

# Debian

# Locales
sed -i 's/# it_IT.UTF-8 UTF-8/it_IT.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/# ro_RO.UTF-8 UTF-8/ro_RO.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/# ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen

locale-gen >> $LOG_FILE 2>&1
# echo 'LANG=nl_BE.UTF-8' > /etc/default/locale

# Timezone
echo "Europe/Rome" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata >> $LOG_FILE 2>&1

# Console keyboard
sed -i 's/XKBLAYOUT=.*/XKBLAYOUT="be"/' /etc/default/keyboard
setupcon --force >> $LOG_FILE 2>&1

# Host file
echo 127.0.0.1 $APP_DOMAIN $ALIAS_DOMAIN >> /etc/hosts

# Sync package index files
apt update >> $LOG_FILE 2>&1
