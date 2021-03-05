  kubeadm join 172.29.50.30:6443 --token abcdef.0123456789abcdef \
    --discovery-token-ca-cert-hash sha256:f3b46b10b213f7eba0bb513491b1870b54ee672b970c2a498cd5d4fa55391ecd \
    --control-plane \
    --apiserver-advertise-address=172.29.50.32

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 172.29.50.30:6443 --token abcdef.0123456789abcdef \
    --discovery-token-ca-cert-hash sha256:f3b46b10b213f7eba0bb513491b1870b54ee672b970c2a498cd5d4fa55391ecd \
    --apiserver-advertise-address=172.29.50.33




  kubeadm join 172.29.50.30:6443 --token abcdef.0123456789abcdef \
    --discovery-token-ca-cert-hash sha256:f3b46b10b213f7eba0bb513491b1870b54ee672b970c2a498cd5d4fa55391ecd \
    --control-plane



    root@worker-01:~# kubeadm join 172.29.50.30:6443 --token abcdef.0123456789abcdef \
>     --discovery-token-ca-cert-hash sha256:f3b46b10b213f7eba0bb513491b1870b54ee672b970c2a498cd5d4fa55391ecd
[preflight] Running pre-flight checks
[preflight] Reading configuration from the cluster...
[preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Starting the kubelet
[kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.



kubectl apply -f https://docs.projectcalico.org/v3.16/manifests/calico.yaml



docker pull docker.io/calico/cni:v3.18.0
docker pull docker.io/calico/pod2daemon-flexvol:v3.18.0
docker pull docker.io/calico/node:v3.18.0
docker pull docker.io/calico/kube-controllers:v3.18.0