#!/bin/bash

# Tools
apt install -y zip unzip curl git vim nano apt-transport-https build-essential \
    libbz2-dev libxml2-dev libcurl4-openssl-dev libjpeg-dev libpng-dev libxpm-dev \
    libfreetype6-dev libc-client2007e-dev libkrb5-dev libmcrypt-dev libpq-dev \
    libmariadbclient-dev-compat libxml2-dev libcurl4-openssl-dev ldap-utils \
    ldapscripts libpcre3-dev libbz2-dev libjpeg-dev libpng-dev libfreetype6-dev \
    libmhash-dev freetds-dev unixodbc-dev libxslt1-dev libgmp-dev libldap2-dev \
    libfcgi-dev libfcgi0ldbl libssl-dev checkinstall autoconf systemtap sqlite3 \
    systemtap-sdt-dev bcc pkg-config libghc-regex-pcre-doc pcre2-utils libpcre++-dev \
    libpcre-ocaml libpcre-ocaml-dev libcurl4-openssl-dev spell insserv libedit-dev \
    libreadline-dev libpspell-dev apt-transport-https lsb-release ca-certificates \
    apache2-dev libsystemd-dev bc >> $LOG_FILE 2>&1

ln -s /usr/lib/libc-client.a /usr/lib/x86_64-linux-gnu/libc-client.a >> $LOG_FILE 2>&1
ln -s /usr/include/x86_64-linux-gnu/curl /usr/local/include/curl >> $LOG_FILE 2>&1
ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/local/include/gmp.h >> $LOG_FILE 2>&1

apt install -y libcurl4-gnutls-dev >> $LOG_FILE 2>&1
