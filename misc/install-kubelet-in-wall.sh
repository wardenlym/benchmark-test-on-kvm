sudo vim /etc/apt/sources.list.d/kubernetes.list

加入：deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main

cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF

apt update

gpg --keyserver keyserver.ubuntu.com --recv-keys 836F4BEB
gpg --export --armor 836F4BEB | sudo apt-key add -

apt update
apt install -y kubelet=1.19.7-00 kubeadm=1.19.7-00

 journalctl -u kubelet -f -n 100



root@k8s-master-1:/data/kubeadm#  docker info | grep Cgroup
WARNING: No swap limit support
 Cgroup Driver: systemd

 