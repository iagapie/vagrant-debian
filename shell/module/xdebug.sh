#!/bin/bash

# PHP Xdebug

XDEBUG_VERSIONS=(
    2.5.5
    2.6.0alpha1
)

XDEBUG_URL='https://xdebug.org/files/'

SRC='/usr/local/src/'

for XDEBUG_VERSION in ${XDEBUG_VERSIONS[@]}; do
    PACKAGE=xdebug-${XDEBUG_VERSION}.tgz

    if [ ! -f "${SRC}${PACKAGE}" ]; then
        wget -O ${SRC}${PACKAGE} ${XDEBUG_URL}${PACKAGE} >> ${LOG_FILE} 2>&1
    fi
done

for PHP_VERSION in ${PHP_VERSIONS[@]}; do
    PHPIZE=/usr/bin/phpize${PHP_VERSION}
    PHPCONFIG=/usr/bin/php-config${PHP_VERSION}

    if [ -f "${PHPIZE}" ]; then
        XDEBUG_VERSION=$([ $(echo "${PHP_VERSION} < 7.2"|bc) -eq 1 ] && echo ${XDEBUG_VERSIONS[0]} || echo ${XDEBUG_VERSIONS[-1]})
        PACKAGE=xdebug-${XDEBUG_VERSION}.tgz
        
        if [ ! -f "${SRC}xdebug-${XDEBUG_VERSION}" ]; then
            tar -xf ${SRC}${PACKAGE} -C ${SRC} >> ${LOG_FILE} 2>&1
        fi

        cd ${SRC}xdebug-${XDEBUG_VERSION}

        CFLAGS="-Wall -Werror -Wextra -Wmaybe-uninitialized -Wdeclaration-after-statement -Wmissing-field-initializers -Wshadow -Wno-unused-parameter -ggdb3" \
            ${PHPIZE} >> ${LOG_FILE} 2>&1
        LDFLAGS=-lncurses ./configure \
            --with-libedit \
            --enable-xdebug \
            --with-php-config=${PHPCONFIG} >> ${LOG_FILE} 2>&1
        make clean >> ${LOG_FILE} 2>&1
        make -j 4 all >> ${LOG_FILE} 2>&1
        make install >> ${LOG_FILE} 2>&1
        cat ${CONFIG_PATH}/php/xdebug.ini > /etc/php/${PHP_VERSION}/mods-available/xdebug.ini
        ln -s /etc/php/${PHP_VERSION}/mods-available/xdebug.ini /etc/php/${PHP_VERSION}/cli/conf.d/20-xdebug.ini >> ${LOG_FILE} 2>&1
        ln -s /etc/php/${PHP_VERSION}/mods-available/xdebug.ini /etc/php/${PHP_VERSION}/fpm/conf.d/20-xdebug.ini >> ${LOG_FILE} 2>&1

        systemctl restart php${PHP_VERSION}-fpm >> ${LOG_FILE} 2>&1
    fi
done
