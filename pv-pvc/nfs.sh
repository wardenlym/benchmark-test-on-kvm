
# Centos上安装nfs
yum -y install nfs-utils rpcbind

# 增加配置文件

cat /etc/exports
/data/nfs    172.29.50.0/24(rw,sync,no_root_squash)

# 启动服务

systemctl start rpcbind.service
systemctl status rpcbind.service
systemctl enable rpcbind.service

systemctl start nfs.service
systemctl enable nfs.service
systemctl status nfs.service

# 在使用端ubuntu安装工具验证状态
apt install nfs-common

root@master-01:~# showmount -e 172.29.50.28
Export list for 172.29.50.28:
/data/nfs 172.29.50.0/24

mount -t nfs 172.29.50.28:/data/nfs /mnt  # (挂载至本地/mnt目录)
df -h
umount /mnt

cat <<EOF > pv-nsf28.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-nfs28
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteMany
  nfs:
    path: /data/nfs
    server: 172.29.50.28
EOF
kubectl apply -f pv-nsf28.yaml

kubectl get pv --all-namespaces

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-nfs28
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteMany
  nfs:
    path: /data/nfs
    server: 172.29.50.28
EOF


cat <<EOF > pvc-28.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-28
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 5Gi
EOF
kubectl apply -f pvc-28.yaml

cat <<EOF > redis-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis
spec:
  selector:
    matchLabels:
      app: redis
  revisionHistoryLimit: 2
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
      - image: redis
        name: redis
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 6379
          name: redis6379
        env:
        - name: ALLOW_EMPTY_PASSWORD
          value: "yes"
        - name: REDIS_PASSWORD
          value: "redis"
        volumeMounts:
        - name: redis-persistent-storage
          mountPath: /data
      volumes:
      - name: redis-persistent-storage
        nfs:
          path: /data/nfs
          server: 172.29.50.28
EOF

cat <<EOF > redis-deployment2-claim.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis
spec:
  selector:
    matchLabels:
      app: redis
  revisionHistoryLimit: 2
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
      - image: redis
        name: redis
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 6379
          name: redis6379
        env:
        - name: ALLOW_EMPTY_PASSWORD
          value: "yes"
        - name: REDIS_PASSWORD
          value: "redis"
        volumeMounts:
        - name: redis-persistent-storage
          mountPath: /data
      volumes:
      - name: redis-persistent-storage
        persistentVolumeClaim:
          claimName: pvc-28
EOF

