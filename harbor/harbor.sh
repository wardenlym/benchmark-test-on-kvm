docker daemon.json registry-mirrors中增加harbor地址
https://registry.com:port

验证
docker login registry.com:port

在集群中增加访问secret
kubectl create secret docker-registry harbor-secret --namespace=default \
    --docker-server=registry.com:port --docker-username=admin \
    --docker-password=xxxx

helm upgrade kube-prometheus-stack prometheus-community/kube-prometheus-stack -f kube-prometheus-stack-values.yml --version 13.13.1 --namespace monitoring

