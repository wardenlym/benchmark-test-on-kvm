kubectl -n monitoring create secret generic etcd-client-cert --from-file=/etc/kubernetes/pki/etcd/peer.crt --from-file /etc/kubernetes/pki/etcd/peer.key --from-file=/etc/kubernetes/pki/etcd/ca.crt

test:
# 这两个都可以
# curl https://localhost:2379/metrics -k --cert /etc/kubernetes/pki/etcd/ca.crt --key /etc/kubernetes/pki/etcd/ca.key
curl https://localhost:2379/metrics -k --cert /etc/kubernetes/pki/etcd/peer.crt --key /etc/kubernetes/pki/etcd/peer.key



  - command:
    - etcd
    - --advertise-client-urls=https://172.29.50.31:2379
    - --cert-file=/etc/kubernetes/pki/etcd/server.crt
    - --client-cert-auth=true
    - --data-dir=/var/lib/etcd
    - --initial-advertise-peer-urls=https://172.29.50.31:2380
    - --initial-cluster=master-01=https://172.29.50.31:2380
    - --key-file=/etc/kubernetes/pki/etcd/server.key
    - --listen-client-urls=https://127.0.0.1:2379,https://172.29.50.31:2379
    - --listen-metrics-urls=http://127.0.0.1:2381
    - --listen-peer-urls=https://172.29.50.31:2380
    - --name=master-01
    - --peer-cert-file=/etc/kubernetes/pki/etcd/peer.crt
    - --peer-client-cert-auth=true
    - --peer-key-file=/etc/kubernetes/pki/etcd/peer.key
    - --peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
    - --snapshot-count=10000
    - --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt


- --advertise-client-urls=https://172.29.50.31:2379        # etcd客户使用，客户通过该地址与本member交互信息。一定要保证从客户侧能可访问该地址
- --cert-file=/etc/kubernetes/pki/etcd/server.crt          # 客户端服务器TLS证书文件的路径
- --client-cert-auth=true
- --data-dir=/var/lib/etcd
- --initial-advertise-peer-urls=https://172.29.50.31:2380
- --initial-cluster=master-01=https://172.29.50.31:2380
- --key-file=/etc/kubernetes/pki/etcd/server.key           # 客户端服务器TLS密钥文件的路径
- --listen-client-urls=https://127.0.0.1:2379,https://172.29.50.31:2379
- --listen-metrics-urls=http://127.0.0.1:2381
- --listen-peer-urls=https://172.29.50.31:2380
- --name=master-01
- --peer-cert-file=/etc/kubernetes/pki/etcd/peer.crt       # path to the peer server TLS cert file.
- --peer-client-cert-auth=true
- --peer-key-file=/etc/kubernetes/pki/etcd/peer.key        # path to the peer server TLS key file.
- --peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt   # path to the peer server TLS trusted CA file.
- --snapshot-count=10000
- --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt        # 客户端服务器TLS信任CA证书文件的路径