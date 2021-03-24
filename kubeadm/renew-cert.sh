kubeadm alpha certs check-expiration

kubeadm alpha certs renew all

# 每次只能renew 1年
# https://mritd.com/2020/01/21/how-to-extend-the-validity-of-your-kubeadm-certificate/
总结一下，调整 kubeadm 证书期限有两种方案；第一种直接修改源码，耗时耗力还得会 go，最后还要跑跨平台编译(很耗时)；第二种在启动集群时调整 kube-controller-manager 组件的 --experimental-cluster-signing-duration 参数，集群创建好后手动 renew 一下并批准相关 csr。

controllerManager:
  extraArgs:
    v: "4"
    node-cidr-mask-size: "19"
    deployment-controller-sync-period: "10s"
    # 在 kubeadm 配置文件中设置证书有效期为 10 年
    experimental-cluster-signing-duration: "86700h"
    node-monitor-grace-period: "20s"
    pod-eviction-timeout: "2m"
    terminated-pod-gc-threshold: "30"
