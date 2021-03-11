docker daemon.json registry-mirrors中增加harbor地址
https://registry.com:port

验证
docker login registry.com:port

在集群中增加访问secret
kubectl create secret docker-registry harbor-secret --namespace=default \
    --docker-server=registry.com:port --docker-username=admin \
    --docker-password=xxxx

helm upgrade kube-prometheus-stack prometheus-community/kube-prometheus-stack -f kube-prometheus-stack-values.yml --version 13.13.1 --namespace monitoring


升级centos系统内核版本:
https://stackoverflow.com/questions/52109039/nslookup-cant-resolve-kubernetes-default  问题1 nslookup 问题换 busybox1.28



https://kubernetes.io/zh/docs/tasks/administer-cluster/dns-debugging-resolution/#known-issues



http://team.jiunile.com/blog/2020/05/k8s-1-18-ipvs-problem.html