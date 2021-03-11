kubectl -n monitoring create secret generic etcd-client-cert --from-file=/etc/kubernetes/pki/etcd/ca.key --from-file /etc/kubernetes/pki/etcd/ca.crt

test:
curl https://localhost:2379/metrics -k --cert /etc/kubernetes/pki/etcd/ca.crt --key /etc/kubernetes/pki/etcd/ca.key
