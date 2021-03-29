https://blog.51cto.com/14268033/2455507

K8s 从入门到放弃系列 https://blog.51cto.com/14268033/2489714

centos7.5搭建k8s1.11.2多master多node的高可用集群 https://blog.csdn.net/liver_life/article/details/81773339


cat  /etc/hosts

192.168.10.11  node1        #master1

192.168.10.14  node4        #master2

192.168.10.15  node5        #master3

3、关闭防火墙

systemctl stop firewalld && systemctl disable firewalld

iptables -F && iptables -X && iptables -F -t nat && iptables -X -t nat && iptables -P FORWARD ACCEPT


4、关闭SELinux

setenforce 0

sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config

5、关闭 swap 分区

swapoff -a

sed -i '/swap/s/^\(.*\)$/#\1/g' /etc/fstab


6、加载内核模块

cat > /etc/sysconfig/modules/ipvs.modules <<EOF

#!/bin/bash

modprobe -- ip_vs

modprobe -- ip_vs_rr

modprobe -- ip_vs_wrr

modprobe -- ip_vs_sh

modprobe -- nf_conntrack_ipv4

modprobe -- br_netfilter

EOF

chmod 755 /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules



7、设置内核参数

cat << EOF | tee /etc/sysctl.d/k8s.conf

net.bridge.bridge-nf-call-iptables=1

net.bridge.bridge-nf-call-ip6tables=1

net.ipv4.ip_forward=1

net.ipv4.tcp_tw_recycle=0

vm.swappiness=0

vm.overcommit_memory=1

vm.panic_on_oom=0

fs.inotify.max_user_watches=89100

fs.file-max=52706963

fs.nr_open=52706963

net.ipv6.conf.all.disable_ipv6=1

net.netfilter.nf_conntrack_max=2310720

EOF

sysctl -p /etc/sysctl.d/k8s.conf


 8、安装Docker

yum install -y yum-utils device-mapper-persistent-data lvm2

yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

yum makecache fast

yum install -y docker-ce-18.09.6

systemctl start docker

systemctl enable docker


安装完成后配置启动时的命令，否则docker会将iptables FORWARD chain的默认策略设置为DROP

另外Kubeadm建议将systemd设置为cgroup驱动，所以还要修改daemon.json

sed -i "13i ExecStartPost=/usr/sbin/iptables -P FORWARD ACCEPT" /usr/lib/systemd/system/docker.service


tee /etc/docker/daemon.json <<-'EOF'

{  "exec-opts": ["native.cgroupdriver=systemd"]  }

EOF

systemctl daemon-reload

systemctl restart docker



 9、安装kubeadm和kubelet

cat <<EOF > /etc/yum.repos.d/kubernetes.repo

[kubernetes]

name=Kubernetes

baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/

enabled=1

gpgcheck=0

repo_gpgcheck=0

gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg

EOF

yum makecache fast


yum install -y kubelet kubeadm kubectl

systemctl enable kubelet


vim /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf

#设置kubelet的cgroup driver

KUBELET_KUBECONFIG_ARGS=--cgroup-driver=systemd


systemctl daemon-reload

systemctl restart kubelet.service

10、拉取所需镜像

kubeadm config images list | sed -e 's/^/docker pull /g' -e 's#k8s.gcr.io#registry.cn-hangzhou.aliyuncs.com/google_containers#g' | sh -x

docker images | grep registry.cn-hangzhou.aliyuncs.com/google_containers | awk '{print "docker tag",$1":"$2,$1":"$2}' | sed -e 's/registry.cn-hangzhou.aliyuncs.com\/google_containers/k8s.gcr.io/2' | sh -x

docker images | grep registry.cn-hangzhou.aliyuncs.com/google_containers | awk '{print "docker rmi """$1""":"""$2}' | sh -x



