#!/bin/bash
set -e

cd /data/src
tar -zxvf mongodb-1.5.5.tgz
cd mongodb-1.5.5
/usr/local/php/bin/phpize
./configure \
  --with-php-config=/usr/local/php/bin/php-config
make 
make install
echo "extension=mongodb.so" >> /usr/local/php/lib/php.ini

cd /data/src 
rm -rf mongodb-1.5.5
