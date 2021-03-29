# kubeadm搭建stacked etcd集群

### 简介
本文使用[官方文档](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/ha-topology/) 
中描述中的第一种：stacked etcd模式搭建高可用集群

每个master节点运行
`kube-apiserver` `kube-scheduler` `kube-controller-manager` `etcd` 实例。

`kube-apiserver` 使用负载均衡器暴露给工作节点。

### 环境信息

前提条件是各机器已经配置ssh互信访问，安装了docker并配置为systemd驱动，见 `问题记录-1`

其他检查：

```
swapoff
各节点hosts主机名
关闭防火墙 firewalld ufw disable
关闭selinux
安装ntp服务同步时间
net.ipv4.ip_nonlocal_bind = 1
net.ipv4.ip_forward = 1
```

#### node分配

```
IP             hostname      role
172.29.30.109  k8s-master-1  controlplane etcd
172.29.30.110  k8s-master-2  controlplane etcd
172.29.30.110  k8s-master-2  controlplane etcd
172.29.30.250                用于api-server负载均衡的vip
172.29.30.112  k8s-worker-1  可选worker 本次配置了master节点允许调度pod,可作为worker角色
```

#### 组件版本信息

```
OS             ubuntu-18.04.3-lts 4.15.0-135-generic
Docker         v19.03.14
Kubernetes     v1.19.7
CNI            calico-v3.13.5
```

### 为 kube-apiserver 创建负载均衡器

无论哪种方法配置高可用集群，第一步都需要为apiserver配置负载均衡，然后确保负载均衡器的地址始终匹配 kubeadm 的 `ControlPlaneEndpoint` 地址。

* 也可以使用DNS解析做负载均衡，只要apiserver的三个ip能进行高可用访问即可，本次使用的是虚拟ip的方式

安装 haproxy 和 keepalived

```bash
sudo apt install -y haproxy keepalived
```
修改 master1 节点 keepalived 配置文件，master2和master3设置为backup，修改权重

```bash
[root@k8s-master-1 ~]# cat /etc/keepalived/keepalived.conf 
! Configuration File for keepalived

global_defs {
   router_id LVS_DEVEL

# 添加如下内容
   script_user root
   enable_script_security
}

vrrp_script check_haproxy {
    script "/etc/keepalived/check_haproxy.sh"         # 检测脚本路径
    interval 3
    weight -2 
    fall 10
    rise 2
}

vrrp_instance VI_1 {
    state MASTER            # MASTER  #master2 和 master3 设置为BACKUP
    interface ens3          # 本机网卡名
    virtual_router_id 51
    priority 100             # 权重100  #master2 和 master3分别是 99 98
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        172.29.30.250      # 虚拟IP
    }
    track_script {
        check_haproxy       # 模块
    }
}
```

三台master节点haproxy配置都一样

```bash
root@k8s-master-1:~# cat /etc/haproxy/haproxy.cfg
global
        log /dev/log    local0
        log /dev/log    local1 notice
        chroot /var/lib/haproxy
        stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
        stats timeout 30s
        user haproxy
        group haproxy
        daemon

        # Default SSL material locations
        ca-base /etc/ssl/certs
        crt-base /etc/ssl/private

        # Default ciphers to use on SSL-enabled listening sockets.
        # For more information, see ciphers(1SSL). This list is from:
        #  https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
        # An alternative list with additional directives can be obtained from
        #  https://mozilla.github.io/server-side-tls/ssl-config-generator/?server=haproxy
        ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:!aNULL:!MD5:!DSS
        ssl-default-bind-options no-sslv3

defaults
        log     global
        mode    http
        option  httplog
        option  dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000
        errorfile 400 /etc/haproxy/errors/400.http
        errorfile 403 /etc/haproxy/errors/403.http
        errorfile 408 /etc/haproxy/errors/408.http
        errorfile 500 /etc/haproxy/errors/500.http
        errorfile 502 /etc/haproxy/errors/502.http
        errorfile 503 /etc/haproxy/errors/503.http
        errorfile 504 /etc/haproxy/errors/504.http

#---------------------------------------------------------------------
# main frontend which proxys to the backends
#---------------------------------------------------------------------
frontend  kubernetes-apiserver
    mode                        tcp
    bind                        *:16443
    option                      tcplog
    default_backend             kubernetes-apiserver

#---------------------------------------------------------------------
# static backend for serving up images, stylesheets and such
#---------------------------------------------------------------------
listen stats
    bind            *:1080
    stats auth      admin:awesomePassword
    stats refresh   5s
    stats realm     HAProxy\ Statistics
    stats uri       /admin?stats

#---------------------------------------------------------------------
# round robin balancing between the various backends
#---------------------------------------------------------------------
backend kubernetes-apiserver
    mode        tcp
    balance     roundrobin
    server  k8s-master-1 172.29.30.109:6443 check
    server  k8s-master-2 172.29.30.110:6443 check
    server  k8s-master-3 172.29.30.111:6443 check
```

每台master设置好健康检查脚本，设置可执行权限

```bash
root@k8s-master-1:~# cat /etc/keepalived/check_haproxy.sh
#!/bin/sh
# HAPROXY down
A=`ps -C haproxy --no-header | wc -l`
if [ $A -eq 0 ]
then
        systmectl start haproxy
        if [ ps -C haproxy --no-header | wc -l -eq 0 ]
        then
                killall -9 haproxy
                echo "HAPROXY down" | mail -s "haproxy"
                sleep 3600
        fi

fi

root@k8s-master-1:~# chmod +x /etc/keepalived/check_haproxy.sh

#之后启动
systemctl start keepalived && systemctl enable keepalived
systemctl start haproxy && systemctl enable haproxy
```

查看 master1 上 vip 已经生效，可以用 `nc -v LOAD_BALANCER_IP PORT` 测试连通，由于 apiserver 尚未运行，预期会出现一个连接拒绝错误，而非超时。（这里是已经启动集群了，所以提示成功）

```bash
root@k8s-master-1:~# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: ens3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:b1:47:c0 brd ff:ff:ff:ff:ff:ff
    inet 172.29.30.109/24 brd 172.29.30.255 scope global ens3
       valid_lft forever preferred_lft forever
    inet 172.29.30.250/32 scope global ens3                   # 虚拟IP
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:feb1:47c0/64 scope link
       valid_lft forever preferred_lft forever
3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default
    link/ether 02:42:6b:5e:24:1d brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:6bff:fe5e:241d/64 scope link
       valid_lft forever preferred_lft forever
       
root@k8s-master-1:~# nc -v 172.29.30.250 16443
Connection to 172.29.30.250 16443 port [tcp/*] succeeded!

```



### 配置kubeadm启动集群节点

从 repo 源安装 kubeadm 和 kubelet

```bash
# 在 /etc/apt/sources.list.d/kubernetes.list 中加入
# deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main

echo 'deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list
sudo apt update
# 看到提示签名问题后记录hash后8位，替换到下面命令中
gpg --keyserver keyserver.ubuntu.com --recv-keys 836F4BEB
gpg --export --armor 836F4BEB | sudo apt-key add -

# 重新更新
sudo apt update

# 指定版本安装
sudo apt install -y kubelet=1.19.7-00 kubeadm=1.19.7-00 kubectl=1.19.7-00
```

生成默认配置文件

```bash
kubeadm config print init-defaults > kubeadm-config.yaml
```

推荐使用配置文件模式而非命令行参数，这样可以方便持久化配置文件

需要检查或修改其中部分配置：

```bash
root@k8s-master-1:/data/kubeadm# cat kubeadm-config.yaml
apiVersion: kubeadm.k8s.io/v1beta2
bootstrapTokens:
- groups:
  - system:bootstrappers:kubeadm:default-node-token
  token: abcdef.0123456789abcdef
  ttl: 24h0m0s
  usages:
  - signing
  - authentication
kind: InitConfiguration
localAPIEndpoint:
  advertiseAddress: 172.29.30.109  # 本机IP
  bindPort: 6443
nodeRegistration:
  criSocket: /var/run/dockershim.sock
  name: k8s-master-1               # 本主机名
  taints:
  - effect: NoSchedule
    key: node-role.kubernetes.io/master
---
apiServer:
  timeoutForControlPlane: 4m0s
apiVersion: kubeadm.k8s.io/v1beta2
certificatesDir: /etc/kubernetes/pki
clusterName: kubernetes
controlPlaneEndpoint: "172.29.30.250:16443"    # 虚拟IP和haproxy端口
controllerManager: {}
dns:
  type: CoreDNS
etcd:
  local:
    dataDir: /var/lib/etcd
imageRepository: registry.aliyuncs.com/google_containers # 使用了阿里云镜像仓库源
kind: ClusterConfiguration
kubernetesVersion: v1.19.7 # 指定版本
networking:
  dnsDomain: cluster.local
  serviceSubnet: 10.96.0.0/12
  podSubnet: "192.168.0.0/16"  # 因为之后想使用calico模式，这里修改子网cidr方便测试
scheduler: {}

---
apiVersion: kubeproxy.config.k8s.io/v1alpha1
kind: KubeProxyConfiguration
featureGates:
  SupportIPVSProxyMode: true
mode: ipvs
metricsBindAddress: "0.0.0.0:10249" # 开启默认监听metrics地址
```

下载相关镜像

```bash
kubeadm config images pull --config kubeadm-config.yaml
```

如果遇到网络问题，在墙内环境可以从阿里云预拉取镜像

```bash
#!/usr/bin/env bash
images=(
kube-apiserver:v1.19.7
kube-controller-manager:v1.19.7
kube-scheduler:v1.19.7
kube-proxy:v1.19.7
pause:3.2
etcd:3.4.13-0
coredns:1.7.0
)
for imageName in ${images[@]}; do
        docker pull registry.aliyuncs.com/google_containers/$imageName
        docker tag registry.aliyuncs.com/google_containers/$imageName k8s.gcr.io/$imageName
        docker rmi registry.aliyuncs.com/google_containers/$imageName
done
```

执行 kubeadm init 初始化集群

```bash
kubeadm init --config kubeadm-config.yaml
```

* 当[wait-control-plane]步骤出现卡住或报错时，检查kubelet是否正常启动，见 `问题记录-1`

```bash
root@k8s-master-1:/data/kubeadm# kubeadm init --config kubeadm-config.yaml
W0204 16:11:40.414767   19912 configset.go:348] WARNING: kubeadm cannot validate component configs for API groups [kubelet.config.k8s.io kubeproxy.config.k8s.io]
[init] Using Kubernetes version: v1.19.7
[preflight] Running pre-flight checks
[preflight] Pulling images required for setting up a Kubernetes cluster
[preflight] This might take a minute or two, depending on the speed of your internet connection
[preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
[certs] Using certificateDir folder "/etc/kubernetes/pki"
[certs] Generating "ca" certificate and key
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [k8s-master-1 kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 172.29.30.109 172.29.30.250]
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] Generating "front-proxy-ca" certificate and key
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "etcd/ca" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [k8s-master-1 localhost] and IPs [172.29.30.109 127.0.0.1 ::1]
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [k8s-master-1 localhost] and IPs [172.29.30.109 127.0.0.1 ::1]
[certs] Generating "etcd/healthcheck-client" certificate and key
[certs] Generating "apiserver-etcd-client" certificate and key
[certs] Generating "sa" key and public key
[kubeconfig] Using kubeconfig folder "/etc/kubernetes"
[endpoint] WARNING: port specified in controlPlaneEndpoint overrides bindPort in the controlplane address
[kubeconfig] Writing "admin.conf" kubeconfig file
[endpoint] WARNING: port specified in controlPlaneEndpoint overrides bindPort in the controlplane address
[kubeconfig] Writing "kubelet.conf" kubeconfig file
[endpoint] WARNING: port specified in controlPlaneEndpoint overrides bindPort in the controlplane address
[kubeconfig] Writing "controller-manager.conf" kubeconfig file
[endpoint] WARNING: port specified in controlPlaneEndpoint overrides bindPort in the controlplane address
[kubeconfig] Writing "scheduler.conf" kubeconfig file
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Starting the kubelet
[control-plane] Using manifest folder "/etc/kubernetes/manifests"
[control-plane] Creating static Pod manifest for "kube-apiserver"
[control-plane] Creating static Pod manifest for "kube-controller-manager"
[control-plane] Creating static Pod manifest for "kube-scheduler"
[etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"
[wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests". This can take up to 4m0s
[apiclient] All control plane components are healthy after 16.546019 seconds
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config-1.19" in namespace kube-system with the configuration for the kubelets in the cluster
[upload-certs] Skipping phase. Please see --upload-certs
[mark-control-plane] Marking the node k8s-master-1 as control-plane by adding the label "node-role.kubernetes.io/master=''"
[mark-control-plane] Marking the node k8s-master-1 as control-plane by adding the taints [node-role.kubernetes.io/master:NoSchedule]
[bootstrap-token] Using token: abcdef.0123456789abcdef
[bootstrap-token] Configuring bootstrap tokens, cluster-info ConfigMap, RBAC Roles
[bootstrap-token] configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[bootstrap-token] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
[kubelet-finalize] Updating "/etc/kubernetes/kubelet.conf" to point to a rotatable kubelet client certificate and key
[addons] Applied essential addon: CoreDNS
[endpoint] WARNING: port specified in controlPlaneEndpoint overrides bindPort in the controlplane address
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of control-plane nodes by copying certificate authorities
and service account keys on each node and then running the following as root:

  kubeadm join 172.29.30.250:16443 --token abcdef.0123456789abcdef \
    --discovery-token-ca-cert-hash sha256:cf1717b48d50d59e061469de217d9752117e83e1bd3fe21024cf66669f791465 \
    --control-plane

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 172.29.30.250:16443 --token abcdef.0123456789abcdef \
    --discovery-token-ca-cert-hash sha256:cf1717b48d50d59e061469de217d9752117e83e1bd3fe21024cf66669f791465

```

成功时说明第一个master节点已经启动，保存好两条 kubeadm join 命令，不要丢失，之后会分别用于control-plane 和 worker 节点加入该集群。



当集群初始化失败时执行 `kubeadm reset` 重置集群或参见 `环境清理` 一节



在其它两个master节点创建以下目录，把主master节点证书分别复制到从master节点

```bash
mkdir -p /etc/kubernetes/pki/etcd

scp /etc/kubernetes/pki/ca.* root@172.29.30.110:/etc/kubernetes/pki/
scp /etc/kubernetes/pki/sa.* root@172.29.30.110:/etc/kubernetes/pki/
scp /etc/kubernetes/pki/front-proxy-ca.* root@172.29.30.110:/etc/kubernetes/pki/
scp /etc/kubernetes/pki/etcd/ca.* root@172.29.30.110:/etc/kubernetes/pki/etcd/
scp /etc/kubernetes/admin.conf root@172.29.30.110:/etc/kubernetes/

scp /etc/kubernetes/pki/ca.* root@172.29.30.111:/etc/kubernetes/pki/
scp /etc/kubernetes/pki/sa.* root@172.29.30.111:/etc/kubernetes/pki/
scp /etc/kubernetes/pki/front-proxy-ca.* root@172.29.30.111:/etc/kubernetes/pki/
scp /etc/kubernetes/pki/etcd/ca.* root@172.29.30.111:/etc/kubernetes/pki/etcd/
scp /etc/kubernetes/admin.conf root@172.29.30.111:/etc/kubernetes/
```

用之前的命令将其他两个master节点加入集群

```bash
  kubeadm join 172.29.30.250:16443 --token abcdef.0123456789abcdef \
    --discovery-token-ca-cert-hash sha256:cf1717b48d50d59e061469de217d9752117e83e1bd3fe21024cf66669f791465 \
    --control-plane
```

添加1个work节点（可选）

```bash
kubeadm join 172.29.30.250:16443 --token abcdef.0123456789abcdef \
    --discovery-token-ca-cert-hash sha256:cf1717b48d50d59e061469de217d9752117e83e1bd3fe21024cf66669f791465
```

安装网络插件，本次选用calico

```bash
kubectl apply -f https://docs.projectcalico.org/v3.13/manifests/calico.yaml
```

如果有需要，使用下面的命令，允许control plane 上分配工作负载pod

```
kubectl taint nodes --all node-role.kubernetes.io/master-
```

等待网络插件安装完成，可以查看node状态

```bash
root@k8s-master-1:/data/kubeadm# kubectl get nodes
NAME           STATUS   ROLES    AGE   VERSION
k8s-master-1   Ready    master   21h   v1.19.7
k8s-master-2   Ready    master   21h   v1.19.7
k8s-master-3   Ready    master   21h   v1.19.7
k8s-worker-1   Ready    <none>   20h   v1.19.6
```

可以查看一下各组件状态，pod是否都正常处于Running状态

```bash
 kubectl get pod --all-namespaces -o wide
```





### 环境清理

正常情况下执行：

```bash
kubeadm reset
```

检查或用于手动清理时：

```bash
# 清理容器和卷
docker ps -a -q | xargs docker rm -f
docker volume rm $(docker volume ls -q)

# 当使用flannel或canal网络时
ip link del flannel.1

# 移除文件系统目录
rm -rf /var/lib/etcd
rm -rf /etc/kubernetes
rm -rf /etc/cni
rm -rf /opt/cni
rm -rf /var/lib/cni
rm -rf /var/run/calico

# 删除iptable链重启docker
iptables -t filter -F && iptables -t filter -X && systemctl restart docker
```



### 问题记录

#### 1. docker Cgroup Driver 与 kubelet 不一致导致kubelet无法启动

日志报错：k8s node notReady kubelet cgroup driver: "cgroupfs" is different from docker

```bash
root@k8s-master-1:~# docker info | grep Cgroup
 Cgroup Driver: cgroupfs
```

卸载 kubeadm kubelet

修改/etc/docker/daemon.json 增加：

```bash
"exec-opts": ["native.cgroupdriver=systemd"]
```

重启 dockerd service 后查看

```bash
sudo systemctl restart docker
```

driver 已修改

```bash
root@k8s-master-1:~# docker info | grep Cgroup
 Cgroup Driver: systemd
```

重新安装 kubeadm kubelet

