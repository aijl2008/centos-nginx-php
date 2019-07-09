#!/bin/bash
set -e

cd /data/src
mv composer.phar /usr/local/bin/composer
composer global config -g repo.packagist composer https://packagist.laravel-china.org
composer global config secure-http false
su php-fpm -c "composer global config -g repo.packagist composer https://packagist.laravel-china.org"
su php-fpm -c "composer global config secure-http false"