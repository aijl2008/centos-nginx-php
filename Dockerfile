FROM php:7.1-fpm

COPY src /src
COPY sources.list /etc/apt/sources.list
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-enable sockets \
    && docker-php-ext-enable sysvmsg \
    && docker-php-ext-enable sysvsem \
    && docker-php-ext-enable sysvshm \
    && docker-php-ext-enable pcntl \
    && docker-php-ext-enable exif \
    && docker-php-ext-enable calendar \
    && docker-php-ext-with mcrypt \
    && docker-php-ext-with readline \
    && docker-php-ext-with mysqli \
    && docker-php-ext-install pdo_mysql \
    && pecl install /src/redis-5.0.0.tgz \
    && echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini \
    && pecl install /src/mongodb-1.5.5.tgz \
    && echo "extension=mongodb.so" > /usr/local/etc/php/conf.d/mongodb.ini \
    && pecl install /src/gmagick-2.0.5RC1.tgz \
    && echo "extension=gmagick.so" > /usr/local/etc/php/conf.d/gmagick.ini \
    && pecl install /src/imagick-3.4.4.tgz \
    && echo "extension=imagick.so" > /usr/local/etc/php/conf.d/imagick.ini \
    && pecl install /src/grpc-1.22.0.tgz \
    && echo "extension=grpc.so" > /usr/local/etc/php/conf.d/grpc.ini \
    && cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini \
    && rm -rf /src
RUN mv /src/composer.phar /usr/local/bin/composer
RUN chmod 755 /usr/local/bin/composer

WORKDIR /opt
RUN usermod -u 1000 www-data

VOLUME ["/opt"]
