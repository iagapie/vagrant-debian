#!/bin/bash

# Install node.js
curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash - >> $LOG_FILE 2>&1
apt install -y nodejs >> $LOG_FILE 2>&1

# Update node packaged modules
npm update -g npm >> $LOG_FILE 2>&1