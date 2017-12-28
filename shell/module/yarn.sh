curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - >> $LOG_FILE 2>&1
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

apt update >> $LOG_FILE 2>&1
apt install -y yarn >> $LOG_FILE 2>&1
