#基本按照：
https://docs.rancher.cn/docs/rancher2.5/installation/install-rancher-on-k8s/_index
# 设置--set hostname=rancher.my.org 不知道有什么用处，后续也没用到

# 修改svc暴漏nodeport，给nginx 代理
kubectl edit svc -n cattle-system rancher

# rancher.conf增加
upstream rancher_server {
    server 172.29.50.31:32000;
    server 172.29.50.32:32000;
    server 172.29.50.33:32000;
}

# 重置管理员密码
kubectl -n cattle-system exec $(kubectl -n cattle-system get pods -l app=rancher | grep '1/1' | head -1 | awk '{ print $1 }') -- reset-password


# ns出现terminating删不掉得方法
kubectl patch namespace cattle-system -p '{"metadata":{"finalizers":[]}}' --type='merge' -n cattle-system
kubectl delete namespace cattle-system --grace-period=0 --force

kubectl patch namespace fleet-system -p '{"metadata":{"finalizers":[]}}' --type='merge' -n fleet-system
kubectl delete namespace fleet-system --grace-period=0 --force
