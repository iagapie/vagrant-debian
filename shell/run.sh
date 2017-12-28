#!/bin/bash

# Log file
LOG_FILE='/vagrant/vm_build.log'

# Shell provisioner
MODULE_PATH='/vagrant/shell/module'
CONFIG_PATH='/vagrant/shell/config'

# USER='vagrant'
# GROUP='vagrant'

#Config
# DOMAIN_ALIASES='www.debian.test'

# DB_ROOT_PASSWD='061185'

# DB_USER='root'
# DB_PASSWD='061185'

PHP_VERSIONS=(
    5.5
    5.6
    7.0
    7.1
    7.2
)

XDEBUG_VERSIONS=(
    2.5.5
    2.6.0alpha1
)

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
