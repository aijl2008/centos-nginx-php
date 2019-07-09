#!/bin/bash
set -e

repo="http://mirrors.aliyun.com/repo/Centos-7.repo"
echo "准备更新 $repo";
curl -o /etc/yum.repos.d/CentOS-Base.repo -s $repo
echo "更新成功";

echo "准备安装 epel-release"
yum install -y epel-release
echo "安装成功"

repo="https://mirror.webtatic.com/yum/el7/webtatic-release.rpm"
echo "准备安装 $repo"
rpm -ivh $repo
echo "安装成功

repo="https://www.atomicorp.com/channels/atomic/centos/7/x86_64/RPMS/atomic-release-1.0-21.el7.art.noarch.rpm"
echo "准备安装 $repo"
rpm -ivh $repo
echo "安装成功