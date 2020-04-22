### k8s部署流程大概说明
> 说明: 所有的脚本并非让你直接执行,要根据情况修改内容

#### 操作过程执行顺序:
+ pre-install.sh
+ harbor-install.sh
+ docker-install.sh
+ k8s-install.sh
+ helm-install.sh

#### 介绍脚本
脚本: pre-install.sh

此脚本主要做一些系统的初始化化操作,包括:

+ 安装常用命令

+ 关闭防火墙和selinux

+ 关闭swap

+ 配置k8s所建议内核参数,开启ipvs模块

+ 创建时间同步任务

脚本: harbor-install.sh

此脚本:

+ 安装harbor私有仓库
+ 配置https证书

> 脚本内有注释内容,详细看下,用于docker访问认证

脚本: docker-install.sh

此脚本:

+ 安装docker
+ 安装docker-compose

脚本: k8s-install.sh

此脚本:

+ 安装kubeadm
+ 拉取k8s所需镜像打tag为私有镜像并push到私有仓库
+ 初始化k8s集群
+ 创建flannel网络

脚本: helm-install.sh

此脚本:

+ 安装helm
+ 介绍harbor如何添加helm插件集成charts仓库