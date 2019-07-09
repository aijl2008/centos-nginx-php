#!/bin/bash
set -e
groupadd -f -g 501 www-data
useradd -m -u 501 -g 501 www-data
mkdir -p /data/webroot && chown www-data:www-data /data/webroot
mkdir -p /data/logs/nginx
su www-data -c "echo '<?php phpinfo();?>' > /data/webroot/phpinfo.php"

cd /data/src && wget -nv http:/nginx.org/download/nginx-1.12.2.tar.gz
tar -zxvf nginx-1.12.2.tar.gz
cd nginx-1.12.2
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
    --with-stream_ssl_preread_module
make && make install
mkdir -p /usr/local/conf/vhost
mkdir -p /data/logs/nginx

rm -rf /data/src/nginx-1.12.2
