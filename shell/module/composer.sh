#!/bin/bash

# composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin >> $LOG_FILE 2>&1
ln -s /usr/bin/composer.phar /usr/bin/composer >> $LOG_FILE 2>&1
