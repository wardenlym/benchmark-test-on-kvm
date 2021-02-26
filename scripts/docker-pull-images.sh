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


docker pull rancher/coreos-etcd:v3.4.13-rancher1
docker pull rancher/rke-tools:v0.1.69
docker pull rancher/k8s-dns-kube-dns:1.15.10
docker pull rancher/k8s-dns-dnsmasq-nanny:1.15.10
docker pull rancher/k8s-dns-sidecar:1.15.10
docker pull rancher/cluster-proportional-autoscaler:1.8.1
docker pull rancher/coredns-coredns:1.7.0
docker pull rancher/k8s-dns-node-cache:1.15.13
docker pull rancher/hyperkube:v1.19.7-rancher1
docker pull rancher/coreos-flannel:v0.13.0-rancher1
docker pull rancher/calico-node:v3.16.5
docker pull rancher/calico-cni:v3.16.5
docker pull rancher/calico-kube-controllers:v3.16.5
docker pull rancher/calico-ctl:v3.16.5
docker pull rancher/calico-pod2daemon-flexvol:v3.16.5
docker pull rancher/pause:3.2
docker pull rancher/nginx-ingress-controller:nginx-0.35.0-rancher2
docker pull rancher/nginx-ingress-controller-defaultbackend:1.5-rancher1
docker pull rancher/metrics-server:v0.3.6

docker pull nginx:latest
docker pull busybox:latest