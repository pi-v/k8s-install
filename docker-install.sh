#!/bin/sh

# 安装docker
yum install -y yum-utils
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

yum install docker-ce docker-ce-cli containerd.io

# 安装docker-compose
wget https://github.com/docker/compose/releases/download/1.25.5/docker-compose-Linux-x86_64
mv docker-compose-Linux-x86_64 docker-compose
install docker-compose /usr/local/bin/

