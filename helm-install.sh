#!/bin/sh

# 安装helm

wget https://get.helm.sh/helm-v3.2.0-rc.1-linux-amd64.tar.gz
tar xf helm-v3.2.0-rc.1-linux-amd64.tar.gz
cd linux-amd64
install helm /usr/local/bin/


# harbor 添加helm charts组件

# docker-compose down
# ./install.sh --with-chartmuseum

helm plugin install https://github.com/chartmuseum/helm-push
helm  repo add  mylibrary  https://harbor.opsbible.com/ops
helm repo list
