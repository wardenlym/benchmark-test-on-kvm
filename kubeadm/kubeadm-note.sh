在以上初始化中，实际对 kubernetes 安装产生影响的主要有三个地方:

docker 的 cgroup driver 调整为 systemd，具体参考 docker.service
docker 一定要限制 conatiner 日志大小，防止 apiserver 等日志大量输出导致磁盘占用过大
安装 conntrack 和 ipvsadm，后面可能需要借助其排查问题

Master 配置修改
如果需要修改 conrol plane 上 apiserver、scheduler 等配置，直接修改 kubeadm.yaml 配置文件(所以集群搭建好后务必保存好)，然后执行 kubeadm upgrade apply --config kubeadm.yaml 升级集群既可，升级前一定作好相关备份工作；我只在测试环境测试这个命令工作还可以，生产环境还是需要谨慎

调整 kubelet
node 节点一旦启动完成后，kubelet 配置便不可再修改；如果想要修改 kubelet 配置，可以通过调整 /etc/systemd/system/kubelet.service.d/10-kubeadm.conf 配置文件完成



kubectl -n kube-system get cm kubeadm-configs -o yaml

--upload-certs

https://mritd.com/2020/01/21/set-up-kubernetes-ha-cluster-by-kubeadm/

```yaml
apiVersion: kubeadm.k8s.io/v1beta2
kind: InitConfiguration
localAPIEndpoint:
  # 第一个 master 节点 IP
  advertiseAddress: "172.16.10.21"
  # 6443 留给了 nginx，apiserver 换到 5443
  bindPort: 5443
# 这个 token 使用以下命令生成
# kubeadm alpha certs certificate-key
certificateKey: 7373f829c733b46fb78f0069f90185e0f00254381641d8d5a7c5984b2cf17cd3 
---
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
# 使用外部 etcd 配置
etcd:
  external:
    endpoints:
    - "https://172.16.10.21:2379"
    - "https://172.16.10.22:2379"
    - "https://172.16.10.23:2379"
    caFile: "/etc/etcd/ssl/etcd-root-ca.pem"
    certFile: "/etc/etcd/ssl/etcd.pem"
    keyFile: "/etc/etcd/ssl/etcd-key.pem"
# 网络配置
networking:
  serviceSubnet: "10.25.0.0/16"
  podSubnet: "10.30.0.1/16"
  dnsDomain: "cluster.local"
kubernetesVersion: "v1.17.0"
# 全局 apiserver LB 地址，由于采用了 nginx 负载，所以直接指向本地既可
controlPlaneEndpoint: "127.0.0.1:6443"
apiServer:
  # apiserver 的自定义扩展参数
  extraArgs:
    v: "4"
    alsologtostderr: "true"
    # 审计日志相关配置
    audit-log-maxage: "20"
    audit-log-maxbackup: "10"
    audit-log-maxsize: "100"
    audit-log-path: "/var/log/kube-audit/audit.log"
    audit-policy-file: "/etc/kubernetes/audit-policy.yaml"
    authorization-mode: "Node,RBAC"
    event-ttl: "720h"
    runtime-config: "api/all=true"
    service-node-port-range: "30000-50000"
    service-cluster-ip-range: "10.25.0.0/16"
  # 由于自行定义了审计日志配置，所以需要将宿主机上的审计配置
  # 挂载到 kube-apiserver 的 pod 容器中
  extraVolumes:
  - name: "audit-config"
    hostPath: "/etc/kubernetes/audit-policy.yaml"
    mountPath: "/etc/kubernetes/audit-policy.yaml"
    readOnly: true
    pathType: "File"
  - name: "audit-log"
    hostPath: "/var/log/kube-audit"
    mountPath: "/var/log/kube-audit"
    pathType: "DirectoryOrCreate"
  # 这里是 apiserver 的证书地址配置
  # 为了防止以后出特殊情况，我增加了一个泛域名
  certSANs:
  - "*.kubernetes.node"
  - "172.16.10.21"
  - "172.16.10.22"
  - "172.16.10.23"
  timeoutForControlPlane: 5m
controllerManager:
  extraArgs:
    v: "4"
    # 宿主机 ip 掩码
    node-cidr-mask-size: "19"
    deployment-controller-sync-period: "10s"
    experimental-cluster-signing-duration: "87600h"
    node-monitor-grace-period: "20s"
    pod-eviction-timeout: "2m"
    terminated-pod-gc-threshold: "30"
scheduler:
  extraArgs:
    v: "4"
certificatesDir: "/etc/kubernetes/pki"
# gcr.io 被墙，换成微软的镜像地址
imageRepository: "gcr.azk8s.cn/google_containers"
clusterName: "kuberentes"
---
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
# kubelet specific options here
# 此配置保证了 kubelet 能在 swap 开启的情况下启动
failSwapOn: false
nodeStatusUpdateFrequency: 5s
# 一些驱逐阀值，具体自行查文档修改
evictionSoft:
  "imagefs.available": "15%"
  "memory.available": "512Mi"
  "nodefs.available": "15%"
  "nodefs.inodesFree": "10%"
evictionSoftGracePeriod:
  "imagefs.available": "3m"
  "memory.available": "1m"
  "nodefs.available": "3m"
  "nodefs.inodesFree": "1m"
evictionHard:
  "imagefs.available": "10%"
  "memory.available": "256Mi"
  "nodefs.available": "10%"
  "nodefs.inodesFree": "5%"
evictionMaxPodGracePeriod: 30
imageGCLowThresholdPercent: 70
imageGCHighThresholdPercent: 80
kubeReserved:
  "cpu": "500m"
  "memory": "512Mi"
  "ephemeral-storage": "1Gi"
rotateCertificates: true
---
apiVersion: kubeproxy.config.k8s.io/v1alpha1
kind: KubeProxyConfiguration
# kube-proxy specific options here
clusterCIDR: "10.30.0.1/16"
# 启用 ipvs 模式
mode: "ipvs"
ipvs:
  minSyncPeriod: 5s
  syncPeriod: 5s
  # ipvs 负载策略
  scheduler: "wrr"
```
