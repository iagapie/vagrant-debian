#!/bin/bash

# PHP

wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
apt update >> ${LOG_FILE} 2>&1

for PHP_VERSION in ${PHP_VERSIONS[@]}; do
    echo 'Install PHP '${PHP_VERSION} | tee ${LOG_FILE}

    if [ $PHP_VERSION = '5.5' ]; then
        PHP_MINOR_VERSION=${PHP_VERSION}.38
        SRC='/usr/local/src/'

        PACKAGE=php-${PHP_MINOR_VERSION}.tar.bz2
        DIR=${SRC}php-${PHP_MINOR_VERSION}
        wget -O ${SRC}${PACKAGE} http://php.net/get/${PACKAGE}/from/this/mirror >> ${LOG_FILE} 2>&1
        tar -xf ${SRC}${PACKAGE} -C ${SRC} >> ${LOG_FILE} 2>&1
        rm ${SRC}${PACKAGE}
        cd ${DIR}

        ./configure \
            --with-fpm-user=${USER} \
            --with-fpm-group=${GROUP} \
            --includedir=/usr/include \
            --mandir=/usr/share/man \
            --infodir=/usr/share/info \
            --disable-silent-rules \
            --libdir=/usr/lib/x86_64-linux-gnu \
            --libexecdir=/usr/lib/x86_64-linux-gnu \
            --disable-maintainer-mode \
            --disable-dependency-tracking \
            --prefix=/usr \
            --enable-cgi \
            --enable-cli \
            --enable-fpm \
            --with-fpm-systemd \
            --disable-phpdbg \
            --with-config-file-path=/etc/php/${PHP_VERSION}/cli \
            --with-config-file-scan-dir=/etc/php/${PHP_VERSION}/cli/conf.d \
            --build=x86_64-linux-gnu \
            --host=x86_64-linux-gnu \
            --config-cache \
            --cache-file=/build/php${PHP_VERSION}-${PHP_MINOR_VERSION}/config.cache \
            --libdir=/usr/lib/php \
            --libexecdir=/usr/lib/php \
            --datadir=/usr/share/php/${PHP_VERSION} \
            --program-suffix=${PHP_VERSION} \
            --sysconfdir=/etc \
            --localstatedir=/var \
            --mandir=/usr/share/man \
            --disable-all \
            --disable-debug \
            --disable-rpath \
            --disable-static \
            --with-pic \
            --with-layout=GNU \
            --enable-filter \
            --with-openssl=no \
            --with-pcre-regex \
            --enable-hash \
            --with-mhash=/usr \
            --enable-libxml \
            --enable-session \
            --with-system-tzdata \
            --with-zlib=/usr \
            --with-zlib-dir=/usr \
            --enable-dtrace \
            --enable-pcntl \
            --with-mysql=shared \
            --with-mysqli=shared \
            --with-pdo-mysql=shared \
            --with-pdo-pgsql=shared \
            --with-pdo-sqlite=shared \
            --with-mcrypt=shared \
            --enable-mysqlnd=shared \
            --enable-mbstring \
            --with-gd=shared \
            --enable-exif \
            --enable-pdo \
            --with-curl=shared,/usr \
            --enable-opcache \
            --with-xsl=shared \
            --enable-zip \
            --enable-dom \
            --enable-intl \
            --enable-ftp=shared \
            --with-gettext=shared \
            --with-iconv=shared \
            --enable-sockets=shared \
            --enable-tokenizer=shared \
            --enable-simplexml \
            --enable-ctype \
            --with-xmlrpc=shared \
            --enable-soap=shared \
            --with-jpeg-dir=shared,/usr \
            --with-png-dir=shared,/usr \
            --with-xpm-dir=shared,/usr \
            --with-freetype-dir=shared,/usr \
            --with-gmp \
            --with-ldap-sasl \
            --with-mysql-sock=/var/run/mysqld/mysqld.sock \
            --with-sqlite3 \
            --enable-inifile \
            --enable-flatfile \
            --enable-bcmath \
            --with-bz2 \
            --with-pear \
            --enable-calendar \
            --enable-json \
            --with-pspell \
            --enable-xml \
            --with-readline \
            --with-libedit="shared,/usr build_alias=x86_64-linux-gnu host_alias=x86_64-linux-gnu" \
            CFLAGS="-g -O2 -fdebug-prefix-map=/build/php${PHP_VERSION}-${PHP_MINOR_VERSION}=. -fstack-protector-strong -Wformat -Werror=format-security -O2 -Wall -pedantic -fsigned-char -fno-strict-aliasing -g" \
            LDFLAGS="-Wl,-z,relro -Wl,-z,now -Wl,--as-needed" \
            CPPFLAGS="-Wdate-time -D_FORTIFY_SOURCE=2" \
            CXXFLAGS="-g -O2 -fdebug-prefix-map=/build/php${PHP_VERSION}-${PHP_MINOR_VERSION}=. -fstack-protector-strong -Wformat -Werror=format-security" >> ${LOG_FILE} 2>&1

        make >> ${LOG_FILE} 2>&1

        make install >> ${LOG_FILE} 2>&1

        mkdir -p /etc/php/${PHP_VERSION}/cli/conf.d >> ${LOG_FILE} 2>&1
        mkdir -p /etc/php/${PHP_VERSION}/fpm/conf.d >> ${LOG_FILE} 2>&1
        mkdir -p /etc/php/${PHP_VERSION}/fpm/pool.d >> ${LOG_FILE} 2>&1
        mkdir -p /etc/php/${PHP_VERSION}/mods-available >> ${LOG_FILE} 2>&1

        cp -v ${DIR}/php.ini-development /etc/php/${PHP_VERSION}/fpm/php.ini >> ${LOG_FILE} 2>&1
        cp -v ${DIR}/php.ini-development /etc/php/${PHP_VERSION}/cli/php.ini >> ${LOG_FILE} 2>&1

        cat ${CONFIG_PATH}/php/php-fpm.conf > /etc/php/${PHP_VERSION}/fpm/php-fpm.conf
        cat ${CONFIG_PATH}/php/www.conf > /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf

        sed -i 's/PHP_VERSION/'${PHP_VERSION}'/g' /etc/php/${PHP_VERSION}/fpm/php-fpm.conf
        sed -i 's/PHP_VERSION/'${PHP_VERSION}'/g' /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf

        #chown -R ${USER}:${GROUP} ${TRG}/var/log
        #chmod -R 777 ${TRG}/var/log

        cat ${CONFIG_PATH}/php/php-fpm > /etc/init.d/php${PHP_VERSION}-fpm
        cat ${CONFIG_PATH}/php/php-fpm.service > /lib/systemd/system/php${PHP_VERSION}-fpm.service

        sed -i 's/PHP_VERSION/'${PHP_VERSION}'/g' /etc/init.d/php${PHP_VERSION}-fpm
        sed -i 's/PHP_VERSION/'${PHP_VERSION}'/g' /lib/systemd/system/php${PHP_VERSION}-fpm.service

        chmod 755 /etc/init.d/php${PHP_VERSION}-fpm
        insserv php${PHP_VERSION}-fpm >> ${LOG_FILE} 2>&1

        systemctl enable php${PHP_VERSION}-fpm >> ${LOG_FILE} 2>&1
        systemctl daemon-reload >> ${LOG_FILE} 2>&1
        systemctl start php${PHP_VERSION}-fpm >> ${LOG_FILE} 2>&1
    else
        apt install -y php${PHP_VERSION} php${PHP_VERSION}-fpm php${PHP_VERSION}-cli  php${PHP_VERSION}-common \
            php${PHP_VERSION}-mbstring php${PHP_VERSION}-gd php${PHP_VERSION}-intl php${PHP_VERSION}-xml \
            php${PHP_VERSION}-xsl php${PHP_VERSION}-mysql php${PHP_VERSION}-zip php${PHP_VERSION}-sqlite3 \
            php${PHP_VERSION}-opcache php${PHP_VERSION}-json php${PHP_VERSION}-curl php${PHP_VERSION}-bcmath \
            php${PHP_VERSION}-soap php${PHP_VERSION}-dev php${PHP_VERSION}-imap php${PHP_VERSION}-bz2 \
            php${PHP_VERSION}-ldap php${PHP_VERSION}-readline php${PHP_VERSION}-pspell php${PHP_VERSION}-recode \
            >> ${LOG_FILE} 2>&1

        if [ $PHP_VERSION != '7.2' ]; then
            apt install -y php${PHP_VERSION}-mcrypt >> ${LOG_FILE} 2>&1
        fi
    fi

    sed -i 's/;log_level = notice/log_level = warning/' /etc/php/${PHP_VERSION}/fpm/php-fpm.conf

    if [ -f "/etc/php/${PHP_VERSION}/fpm/pool.d/www.conf" ]; then
        sed -i 's/^user = www-data/user = '${USER}'/' /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf
        sed -i 's/^group = www-data/group = '${GROUP}'/' /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf
        sed -i 's/;listen.owner/listen.owner/' /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf
        sed -i 's/;listen.group/listen.group/' /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf
        sed -i 's/;listen.mode/listen.mode/' /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf
    fi

    systemctl restart php${PHP_VERSION}-fpm >> ${LOG_FILE} 2>&1
done
