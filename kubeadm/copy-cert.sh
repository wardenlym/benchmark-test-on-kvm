
https://kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/high-availability/
手动证书分发
如果您选择不将 kubeadm init 与 --upload-certs 命令一起使用， 则意味着您将必须手动将证书从主控制平面节点复制到 将要加入的控制平面节点上。

有许多方法可以实现这种操作。在下面的例子中我们使用 ssh 和 scp：

如果要在单独的一台计算机控制所有节点，则需要 SSH。

在您的主设备上启动 ssh-agent，要求该设备能访问系统中的所有其他节点：

eval $(ssh-agent)
将 SSH 身份添加到会话中：

ssh-add ~/.ssh/path_to_private_key
检查节点间的 SSH 以确保连接是正常运行的

SSH 到任何节点时，请确保添加 -A 标志：

ssh -A 10.0.0.7
当在任何节点上使用 sudo 时，请确保环境完善，以便使用 SSH 转发任务：

sudo -E -s
在所有节点上配置 SSH 之后，您应该在运行过 kubeadm init 命令的第一个控制平面节点上运行以下脚本。 该脚本会将证书从第一个控制平面节点复制到另一个控制平面节点：

在以下示例中，用其他控制平面节点的 IP 地址替换 CONTROL_PLANE_IPS。

USER=ubuntu # 可自己设置
CONTROL_PLANE_IPS="10.0.0.7 10.0.0.8"
for host in ${CONTROL_PLANE_IPS}; do
    scp /etc/kubernetes/pki/ca.crt "${USER}"@$host:
    scp /etc/kubernetes/pki/ca.key "${USER}"@$host:
    scp /etc/kubernetes/pki/sa.key "${USER}"@$host:
    scp /etc/kubernetes/pki/sa.pub "${USER}"@$host:
    scp /etc/kubernetes/pki/front-proxy-ca.crt "${USER}"@$host:
    scp /etc/kubernetes/pki/front-proxy-ca.key "${USER}"@$host:
    scp /etc/kubernetes/pki/etcd/ca.crt "${USER}"@$host:etcd-ca.crt
    scp /etc/kubernetes/pki/etcd/ca.key "${USER}"@$host:etcd-ca.key
done

注意： 只需要复制上面列表中的证书。kubeadm 将负责生成其余证书以及加入控制平面实例所需的 SAN。 如果您错误地复制了所有证书，由于缺少所需的 SAN，创建其他节点可能会失败。
然后，在每个连接控制平面节点上，您必须先运行以下脚本，然后再运行 kubeadm join。 该脚本会将先前复制的证书从主目录移动到 /etc/kubernetes/pki：

USER=ubuntu # 可自己设置
mkdir -p /etc/kubernetes/pki/etcd
mv /home/${USER}/ca.crt /etc/kubernetes/pki/
mv /home/${USER}/ca.key /etc/kubernetes/pki/
mv /home/${USER}/sa.pub /etc/kubernetes/pki/
mv /home/${USER}/sa.key /etc/kubernetes/pki/
mv /home/${USER}/front-proxy-ca.crt /etc/kubernetes/pki/
mv /home/${USER}/front-proxy-ca.key /etc/kubernetes/pki/
mv /home/${USER}/etcd-ca.crt /etc/kubernetes/pki/etcd/ca.crt
mv /home/${USER}/etcd-ca.key /etc/kubernetes/pki/etcd/ca.key