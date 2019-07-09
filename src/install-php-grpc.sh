#!/bin/bash
set -e

cd /data/src 
tar -zxvf grpc-1.22.0.tgz
cd grpc-1.22.0
/usr/local/php/bin/phpize
./configure \
  --with-php-config=/usr/local/php/bin/php-config
make 
make install
echo "extension=redis.so" >> /usr/local/php/lib/php.ini

cd /data/src 
rm -rf grpc-1.22.0