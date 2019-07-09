#!/bin/bash
set -e

cd /data/src
tar -zxvf redis-5.0.0.tgz
cd redis-5.0.0
/usr/local/php/bin/phpize
./configure \
  --with-php-config=/usr/local/php/bin/php-config
make 
make install
echo "extension=redis.so" >> /usr/local/php/lib/php.ini

cd /data/src 
rm -rf redis-5.0.0
