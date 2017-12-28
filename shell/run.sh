#!/bin/bash

# Log file
LOG_FILE='/vagrant/vm_build.log'

# Shell provisioner
MODULE_PATH='/vagrant/shell/module'
CONFIG_PATH='/vagrant/shell/config'

# IP for the vagrant VM
GUEST_IP='192.168.33.33'

USER='vagrant'
GROUP='vagrant'

#Config
APP_DOMAIN='debian.test'
ALIAS_DOMAIN='www.debian.test'

DB_ROOT_PASSWD='061185'
DB_USER='root'
DB_PASSWD='061185'

PHP_VERSIONS=(
    5.5
    5.6
    7.0
    7.1
    7.2
)

#DEFAULT_PHP=${PHP_VERSIONS[-1]}

# Adding an entry here executes the corresponding .sh file in MODULE_PATH
DEPENDENCIES=(
    debian
    tools
    mysql
    php
    xdebug
    composer
    apache
    node
    yarn
)

for MODULE in ${DEPENDENCIES[@]}; do
    echo '-->'${MODULE_PATH}'/'${MODULE}'.sh'
    source ${MODULE_PATH}/${MODULE}.sh
done
