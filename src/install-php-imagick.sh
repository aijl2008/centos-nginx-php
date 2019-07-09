#!/bin/bash
set -e
cd /data/src
tar -zxvf imagick-3.4.4.tgz
cd imagick-3.4.4
/usr/local/php/bin/phpize
./configure \
  --with-php-config=/usr/local/php/bin/php-config
make 
make install
echo "extension=imagick.so" >> /usr/local/lib/php.ini

cd /data/src 
rm -rf imagick-3.4.4