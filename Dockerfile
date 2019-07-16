FROM centos:7
MAINTAINER Jerry Ai <awz@awz.cn>

WORKDIR /data/src

RUN \
curl -o /etc/yum.repos.d/CentOS-Base.repo -s http://mirrors.aliyun.com/repo/Centos-7.repo && \
yum install -y epel-release && \
rpm -ivh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm && \
rpm -ivh https://www.atomicorp.com/channels/atomic/centos/7/x86_64/RPMS/atomic-release-1.0-21.el7.art.noarch.rpm && \
yum install -y gcc && \
yum install -y automake  && \
yum install -y autoconf  && \
yum install -y libtool  && \
yum install -y make gcc-c++ && \
yum install -y net-tools  && \
yum install -y wget  && \
yum install -y tree  && \
yum install -y httpd-tools && \
yum install -y initscripts  && \
yum install -y openssl-devel && \
yum install -y curl-devel && \
yum install -y freetype-devel && \
yum install -y readline-devel && \
yum install -y libxml2-devel && \
yum install -y libicu-devel && \
yum install -y libxslt-devel  && \
yum install -y libmcrypt-devel && \
yum install -y libpng-devel && \
yum install -y libjpeg-devel && \
yum install -y libssh2-devel  && \
yum install -y kde-l10n-Chinese && \
yum install -y glibc-common && \
localedef -c -f UTF-8 -i zh_CN zh_CN.utf8 && \


/usr/sbin/groupadd -f -g 501 www-data && \
/usr/sbin/groupadd -f -g 510 php-fpm && \
/usr/sbin/useradd -m -u 501 -g 501 www-data && \
/usr/sbin/useradd -m -u 510 -g 510 php-fpm && \
mkdir -p /data/webroot && chown www-data:www-data /data/webroot && \
mkdir -p /data/webroot/runtimes && chown php-fpm:php-fpm /data/webroot/runtimes && \
mkdir -p /data/logs/nginx && \
mkdir -p /data/logs/php && \
mkdir -p /usr/local/conf/vhost && \
su www-data -c "echo '<?php phpinfo();?>' > /data/webroot/phpinfo.php" && \

ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
tar -zxvf nginx-1.12.2.tar.gz && \
cd nginx-1.12.2 && \
./configure \
    --prefix=/usr/local/ \
    --error-log-path=/data/logs/nginx/error.log \
    --http-log-path=/data/logs/nginx/access.log \
    --user=www-data \
    --group=www-data \
    --with-compat \
    --with-file-aio \
    --with-threads \
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_mp4_module \
    --with-http_random_index_module \
    --with-http_realip_module \
    --with-http_secure_link_module \
    --with-http_slice_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-stream \
    --with-stream_realip_module \
    --with-stream_ssl_module \
    --with-stream_ssl_preread_module && \
make && make install && \

cd ..  && \
rm -rf nginx-1.12.2 && \
tar -zxvf php-7.1.24.tar.gz && \
cd php-7.1.24 && \

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
  --enable-mysqlnd && \
make && make install && \
ln -s /usr/local/php/bin/* /usr/local/bin && \

cp php.ini-production /usr/local/php/lib/php.ini && \
sed -i "s/display_errors = Off/display_errors = On/" /usr/local/php/lib/php.ini && \
sed -i "s/memory_limit = 128M/memory_limit = 1024M/" /usr/local/php/lib/php.ini && \
sed -i "s/short_open_tag = Off/short_open_tag = On/" /usr/local/php/lib/php.ini && \
sed -i "s/;date.timezone =/date.timezone =Asia\/Shanghai/" /usr/local/php/lib/php.ini && \
sed -i "s/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/" /usr/local/php/lib/php.ini && \
sed -i "s/;error_log = php_errors.log/error_log = \/data\/logs\/php\/php_errors.log/" /usr/local/php/lib/php.ini && \

echo '
[global]
error_log = /data/logs/php/fpm_errors.log
process.max = 128
daemonize = no
include=etc/php-fpm.d/*.conf
' > /usr/local/php/etc/php-fpm.conf  && \

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
' > /usr/local/php/etc/php-fpm.d/pool-1.conf  && \

cd ..  && \
rm -rf php-7.1.24  && \

EXPOSE 80 443
CMD ["/usr/local/php/sbin/php-fpm", "-y", "/usr/local/php/etc/php-fpm.conf"]
ENTRYPOINT ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;", "-c", "/usr/local/nginx/conf/nginx.conf"]
