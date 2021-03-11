kubeadm init --feature-gates CoreDNS=true

Currently, CoreDNS is Alpha in Kubernetes 1.9. We have a roadmap which will make CoreDNS Beta in version 1.10 and eventually be the default DNS, replacing kube-dns.

