
wget https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.4.2/components.yaml


1、在master节点要能访问metrics server pod ip（kubeadm部署默认已经满足该条件，二进制部署需注意要在master节点也部署node组件）
2、apiserver启用聚合层支持（kubeadm默认已经启用，二进制部署需自己启用）

/etc/kubernetes/manifests/kube-apiserver.yaml

添加

- --enable-aggregator-routing=true





yaml里增加两个参数：跳过证书验证和使用node ip通信

--kubelet-insecure-tls
--kubelet-preferred-address-types=InternalIP


- name: metrics-server
        image: registry.cn-shenzhen.aliyuncs.com/carp/metrics-server-amd64:0.3.1
        imagePullPolicy: IfNotPresent
        args:
          - --cert-dir=/tmp
          - --secure-port=4443
          - --kubelet-insecure-tls
          - --kubelet-preferred-address-types=InternalIP


