kubectl -n monitoring create secret generic etcd-client-cert --from-file=/etc/kubernetes/pki/etcd/peer.crt --from-file /etc/kubernetes/pki/etcd/peer.key --from-file=/etc/kubernetes/pki/etcd/ca.crt

test:
curl https://localhost:2379/metrics -k --cert /etc/kubernetes/pki/etcd/ca.crt --key /etc/kubernetes/pki/etcd/ca.key

curl https://localhost:2379/metrics -k --cert /etc/kubernetes/pki/etcd/ca.crt --key /etc/kubernetes/pki/etcd/peer.key



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

kubectl -n monitoring create secret generic etcd-certs --from-file=/etc/kubernetes/ssl/kubernetes.pem --from-file=/etc/kubernetes/ssl/kubernetes-key.pem --from-file=/etc/kubernetes/ssl/k8s-root-ca.pem



        volumeMounts:
        - mountPath: /cert
          name: tls-secret
          readOnly: true
        - mountPath: /etc/prometheus/secrets/etcd-client-cert
          name: etcd-client-cert
          readOnly: true
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext:
        fsGroup: 65534
        runAsGroup: 65534
        runAsNonRoot: true
        runAsUser: 65534
      serviceAccount: kube-prometheus-stack-operator
      serviceAccountName: kube-prometheus-stack-operator
      terminationGracePeriodSeconds: 30
      volumes:
      - name: tls-secret
        secret:
          defaultMode: 420
          secretName: kube-prometheus-stack-admission
      - name: etcd-client-cert
        secret:
          defaultMode: 420
          secretName: etcd-client-cert


