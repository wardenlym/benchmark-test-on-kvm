# join token 默认24小时过期
#token忘记或者ttl过期了的话可以kubeadm token list查看，可以通过kubeadm token create --print-join-command查看
kubeadm token create --print-join-command
