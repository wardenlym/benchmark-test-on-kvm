#!/usr/bin/env bash

which rke
which docker
which kubectl
which helm
which cfssl
which cfssljson

wget -O rke https://github.com/rancher/rke/releases/download/v1.2.4-rc9/rke_linux-amd64

wget http://rancher-mirror.cnrancher.com/helm/v3.5.0/helm-v3.5.0-linux-amd64.tar.gz

# alternative
# wget https://storage.googleapis.com/kubernetes-release/release/v1.19.6/bin/linux/amd64/kubectl

# select version
#curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO https://dl.k8s.io/release/v1.19.6/bin/linux/amd64/kubectl
curl -LO https://dl.k8s.io/release/v1.19.6/bin/linux/amd64/kubeadm
curl -LO https://dl.k8s.io/release/v1.19.6/bin/linux/amd64/kubelet

wget -q --show-progress --https-only --timestamping \
  https://storage.googleapis.com/kubernetes-the-hard-way/cfssl/1.4.1/linux/cfssl \
  https://storage.googleapis.com/kubernetes-the-hard-way/cfssl/1.4.1/linux/cfssljson

ansible -i hosts cluster -m copy -a "src=./kubectl dest=/usr/local/bin/kubectl" --become
ansible -i hosts cluster -m copy -a "src=./kubelet dest=/usr/local/bin/kubelet" --become
ansible -i hosts cluster -m copy -a "src=./kubeadm dest=/usr/local/bin/kubeadm" --become

ansible -i hosts cluster -m copy -a "src=./cfssl dest=/usr/local/bin/cfssl" --become
ansible -i hosts cluster -m copy -a "src=./cfssljson dest=/usr/local/bin/cfssljson" --become

ansible -i hosts cluster -m copy -a "src=./rke dest=/usr/local/bin/rke" --become
ansible -i hosts cluster -m copy -a "src=./helm dest=/usr/local/bin/helm" --become