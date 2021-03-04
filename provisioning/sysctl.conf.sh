# https://blog.csdn.net/engchina/article/details/103331510
# calico: rp_filter=1
# ubuntu20.04 default is 2
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-arptables = 1

sysctl -p