#!/bin/bash
set -e

/usr/sbin/groupadd -f -g 510 php-fpm
/usr/sbin/useradd -m -u 510 -g 510 php-fpm
mkdir -p /data/webroot/runtimes
chown php-fpm:php-fpm /data/webroot/runtimes

cd /data/src

tar -zxvf php-7.1.24.tar.gz
cd php-7.1.24

./configure \
  --prefix=/usr/local/php \
  --enable-fpm \
  --with-fpm-user=php-fpm \
  --with-fpm-group=php-fpm \
  --enable-sigchild \
  --disable-short-tags \
  --with-libxml-dir \
  --with-openssl \
  --with-pcre-regex \
  --with-zlib \
  --enable-calendar \
  --with-curl \
  --enable-exif \
  --with-jpeg-dir \
  --with-png-dir \
  --with-freetype-dir \
  --with-gd \
  --enable-gd-native-ttf \
  --with-gettext \
  --with-mhash \
  --enable-intl\
  --enable-mbstring \
  --with-mcrypt \
  --with-mysqli \
  --enable-pcntl \
  --with-pdo-mysql \
  --with-readline \
  --enable-shmop\
  --enable-soap\
  --enable-sockets \
  --enable-sysvmsg \
  --enable-sysvsem \
  --enable-sysvshm \
  --with-tidy \
  --with-xmlrpc \
  --with-xsl=DIR \
  --enable-zip \
  --enable-mysqlnd
make
make install

ln -s /usr/local/php/bin/* /usr/local/bin

cp php.ini-production /usr/local/php/lib/php.ini
sed -i "s/display_errors = Off/display_errors = On/" /usr/local/php/lib/php.ini
sed -i "s/memory_limit = 128M/memory_limit = 1024M/" /usr/local/php/lib/php.ini
sed -i "s/short_open_tag = Off/short_open_tag = On/" /usr/local/php/lib/php.ini
sed -i "s/;date.timezone =/date.timezone =Asia\/Shanghai/" /usr/local/php/lib/php.ini
sed -i "s/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/" /usr/local/php/lib/php.ini
sed -i "s/;error_log = php_errors.log/error_log = \/data\/logs\/php\/php_errors.log/" /usr/local/php/lib/php.ini

mkdir -p /data/logs/php/php

echo '
[global]
error_log = /data/logs/php/fpm_errors.log
process.max = 128
daemonize = no
include=etc/php-fpm.d/*.conf
' > /usr/local/php/etc/php-fpm.conf

echo '[pool-1]
user = php-fpm
group = php-fpm
listen = 127.0.0.1:9000
pm = static
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3
access.log = /data/logs/php/php/$pool.access.log
slowlog = /data/logs/php/$pool.log.slow
request_slowlog_timeout = 1
' > /usr/local/php/etc/php-fpm.d/pool-1.conf

cd /data/src
rm -rf php-7.1.24