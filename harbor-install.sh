#!/bin/sh

# 证书信息,cn绑定harbor域名地址
L=HN
O=opsbible
CN=harbor.opsbible.com

# 下载离线安装包,比较大,慢慢等
wget https://github.com/goharbor/harbor/releases/download/v1.10.2/harbor-offline-installer-v1.10.2.tgz
tar xf harbor-offline-installer-v1.10.2.tgz
mv harbor /usr/local/

# 制作证书
mkdir secerts
cd secerts

openssl req  -newkey rsa:1024 -nodes -sha256 -keyout ca.key \
  -x509 -days 3650 -out ca.crt -subj "/C=CN/L=$L/O=$O/CN=$CN"
openssl req -newkey rsa:1024 -nodes -sha256 -keyout ${CN}.key \
  -out server.csr -subj "/C=CN/L=$L/O=$O/CN=$CN"
openssl x509 -req -days 3650 -in server.csr -CA ca.crt -CAkey ca.key \
  -CAcreateserial -out ${CN}.crt

cd ..
# 修改harbor.yml 添加证书信息和主机名
sed -ri "s#(hostname:).*#\1 $CN#g" harbor.yml
sed -ri "s#(certificate:).*#\1 /usr/local/harbor/secerts/${CN}.crt#g" harbor.yml
sed -ri "s#(private_key:).*#\1 /usr/local/harbor/secerts/${CN}.key#g" harbor.yml

# 执行安装
./install.sh


# 完毕之后要将所有的docker下添加证书,便于请求https仓库,如果不是https仓库则需要在daemon.json添加一个参数
# mkdir -p /etc/docker/certs.d/harbor.opsbible.com
# scp harbor:/usr/local/harbor/secerts/harbor.opsbible.com.crt /etc/docker/certs.d/harbor.opsbible.com/
# docker login harbor.opsbible.com

# 后期如果修改配置,则执行路径下的 prepare