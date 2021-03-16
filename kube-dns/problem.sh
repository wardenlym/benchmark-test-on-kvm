
处理问题记录：
现象：1. service name解析失败，ping不通 2. 部分节点nodeport 服务端口无法访问

主要原因：
calico选取网卡接口的配置在部分机器上未生效，
问题节点中，双网卡的iface index顺序导致calico在选取iface时出错

```
# 正常的机器上：
2: ens3: <BROADCAST,MU
3: ens8: <BROADCAST,MU
# 有问题的机器上：
2: ens8: <BROADCAST,MU
3: ens3: <BROADCAST,MU
```

处理方法：显式指定iface
// 修改calico.yaml 文件添加以下二行
            - name: IP_AUTODETECTION_METHOD
              value: "interface=ens8"  # 显式指定iface
重启所有calico-node，重启kube-proxy


次要原因：
1. 测试用busybox:latest中的nslookup有问题。影响分析dns解析，换用busybox:1.28
参考： https://stackoverflow.com/questions/52109039/nslookup-cant-resolve-kubernetes-default

2. 社区的一个已知问题：ubuntu做宿主机中需要额外配置--resolv-conf=/run/systemd/resolve/resolv.conf
参考：https://kubernetes.io/zh/docs/tasks/administer-cluster/dns-debugging-resolution/#known-issues

几个问题互相作用导致的现象1和2
全部修改后处理现已正常




升级centos系统内核版本:
http://team.jiunile.com/blog/2020/05/k8s-1-18-ipvs-problem.html


http://team.jiunile.com/blog/2020/05/k8s-1-18-ipvs-problem.html
