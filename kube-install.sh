#!/bin/sh

# 添加kubeadm yum源
cat >/etc/yum.repos.d/kubernetes.repo<<'EOF'
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

# 安装kubeadm 会自动安装依赖的kubelet kubectl
yum install kubeadm -y

# pull下来所有需要的镜像
kubeadm config images pull --image-repository registry.aliyuncs.com/google_containers

# 将pull下来的镜像tag为私有仓库标记
docker images|grep "registry.aliyuncs.com/google_containers/" \
  |awk -F '[ /]+' '{print "docker tag registry.aliyuncs.com/google_containers/"$3":"$4" harbor.opsbible.com/k8s/"$3":"$4}' \
  |bash

# 登录私有仓库
docker login  harbor.opsbible.com

# 上传镜像到私有仓库
docker images|grep harbor|awk '{print "docker push "$1":"$2}'|bash

# 初始话kubeadm 注意,配置文件中要填写harbor的仓库地址
kubeadm init --config kubeadm-config.yaml --upload-certs

# 复制认证配置文件放到指定目录下
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# 部署flanne
kubectl apply -f kube-flannel.yaml

