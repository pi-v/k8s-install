#!/bin/sh

# 关闭防火墙
systemctl stop firewalld
systemctl disable firewalld

# 关闭selinux
sed -i "s#enforcing#disabled#g" /etc/selinux/config
setenforce 0

# 安装常用软件包
yum install lrzsz wget vim openssl-devel ipvsadm gcc-c++ -y

# 时间同步 centos8 设置时区
if [[ $(grep "release 8" /etc/redhat-release|wc -l) == 1 ]];then
  rpm -ivh http://mirrors.wlnmp.com/centos/wlnmp-release-centos.noarch.rpm
  yum install wntp -y
else
  yum install ntpdate -y
fi
echo '*/5 * * * * /usr/local/bin/ntpdate ntp1.aliyun.com >/dev/null 2>&1' >>/var/spool/cron/root
timedatectl set-timezone Asia/Shanghai

# 开启ipvs内核模块
cat >/etc/modules-load.d/ipvs.conf <<'EOF'
# 开机载入ipvs相关模块
ip_vs
ip_vs_sh
ip_vs_rr
ip_vs_wrr
nf_conntrack_ipv4
br_netfilter
EOF

modprobe -- ip_vs
modprobe -- ip_vs_sh
modprobe -- ip_vs_rr
modprobe -- ip_vs_wrr
modprobe -- nf_conntrack_ipv4
modprobe -- br_netfilter

# k8s所需内核优化
cat >/etc/sysctl.d/k8s.conf<<'EOF'
# 前三个最主要
vm.swappiness=0
net.bridge.bridge-nf-call-iptables=1
net.ipv4.ip_forward=1
net.bridge.bridge-nf-call-ip6tables =1
net.ipv4.neigh.default.gc_thresh1=1024
net.ipv4.neigh.default.gc_thresh2=2048
net.ipv4.neigh.default.gc_thresh3=4096
vm.overcommit_memory=1
vm.panic_on_oom=0
fs.inotify.max_user_instances=8192
fs.inotify.max_user_watches=1048576
fs.file-max=52706963
fs.nr_open=52706963
net.ipv6.conf.all.disable_ipv6=1
net.netfilter.nf_conntrack_max=2310720
EOF

sysctl -p /etc/sysctl.d/k8s.conf


# 关闭swap
swapoff -a
sed -i "s@\(.*swap.*\)@#\1@g" /etc/fstab
