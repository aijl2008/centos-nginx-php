#!/bin/bash
set -e

packages=(gcc \
automake \
autoconf \
libtool \
make gcc-c++ \
net-tools \
wget \
tree \
httpd-tools \
initscripts \
openssl-devel \
curl-devel \
freetype-devel \
readline-devel \
libxml2-devel \
libicu-devel \
libxslt-devel \
libmcrypt-devel \
libpng-devel \
libjpeg-devel \
libssh2-devel \
libtidy-devel \
kde-l10n-Chinese \
glibc-common \
)
for var in ${packages[@]};
do
    echo "安装 $var 包"
    yum install -y $var
done
echo "定义本地语言环境"
localedef -c -f UTF-8 -i zh_CN zh_CN.utf8
echo "修改时区"
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
