FROM centos:7
MAINTAINER Jerry Ai <awz@awz.cn>

WORKDIR /data/src
COPY src /data/src

RUN sh /data/src/update.sh
RUN sh /data/src/install-base.sh
RUN sh /data/src/install-php.sh
RUN sh /data/src/install-php-redis.sh
RUN sh /data/src/install-php-mongodb.sh
RUN sh /data/src/install-php-imagick.sh
RUN sh /data/src/install-php-gmagick.sh
RUN sh /data/src/install-php-composer.sh
RUN sh /data/src/install-nginx.sh

ADD conf /usr/local/nginx/conf

EXPOSE 80 443
CMD ["/usr/local/php/sbin/php-fpm", "-y", "/usr/local/php/etc/php-fpm.conf"]
ENTRYPOINT ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;", "-c", "/usr/local/nginx/conf/nginx.conf"]