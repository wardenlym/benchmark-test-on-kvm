
wget https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.4.2/components.yaml


1、在master节点要能访问metrics server pod ip（kubeadm部署默认已经满足该条件，二进制部署需注意要在master节点也部署node组件）
2、apiserver启用聚合层支持（kubeadm默认已经启用，二进制部署需自己启用）

/etc/kubernetes/manifests/kube-apiserver.yaml

添加

- --enable-aggregator-routing=true





yaml里增加两个参数：跳过证书验证和使用node ip通信

--kubelet-insecure-tls
--kubelet-preferred-address-types=InternalIP



https://github.com/kubernetes-sigs/metrics-server/issues/157
      hostNetwork: true #增加
      containers:
      - name: metrics-server
        image: k8s.gcr.io/metrics-server-amd64:v0.3.6
        command:
————————————————
版权声明：本文为CSDN博主「lampNick」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/scun_cg/article/details/106116569

- name: metrics-server
        image: registry.cn-shenzhen.aliyuncs.com/carp/metrics-server-amd64:0.3.1
        imagePullPolicy: IfNotPresent
        args:
          - --cert-dir=/tmp
          - --secure-port=4443
          - --kubelet-insecure-tls
          - --kubelet-preferred-address-types=InternalIP


