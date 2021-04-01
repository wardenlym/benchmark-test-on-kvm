
# Centos上安装nfs
yum -y install nfs-utils rpcbind

# 增加配置文件

cat /etc/exports
/data/nfs    172.29.50.0/24(rw,sync,no_root_squash)

```
#：允许ip地址范围在192.168.0.*的计算机以读写的权限来访问/home/work 目录。  
/home/work 192.168.0.*（rw,sync,root_squash）  
/home  192.168.1.105 (rw,sync)  
/public  * (rw,sync)  

配置文件每行分为两段：第一段为共享的目录，使用绝对路径，第二段为客户端地址及权限。  
地址可以使用完整IP或网段，例如10.0.0.8或10.0.0.0/24，10.0.0.0/255.255.255.0当然也可以地址可以使用主机名，DNS解析的和本地/etc/hosts解析的都行，支持通配符，例如：*.chengyongxu.com  
  
权限有：  
rw：read-write，可读写；    注意，仅仅这里设置成读写客户端还是不能正常写入，还要正确地设置共享目录的权限，参考问题7  
ro：read-only，只读；  
sync：文件同时写入硬盘和内存；  
async：文件暂存于内存，而不是直接写入内存；  
no_root_squash：NFS客户端连接服务端时如果使用的是root的话，那么对服务端分享的目录来说，也拥有root权限。显然开启这项是不安全的。  
root_squash：NFS客户端连接服务端时如果使用的是root的话，那么对服务端分享的目录来说，拥有匿名用户权限，通常他将使用nobody或nfsnobody身份；  
all_squash：不论NFS客户端连接服务端时使用什么用户，对服务端分享的目录来说都是拥有匿名用户权限；  
anonuid：匿名用户的UID值，通常是nobody或nfsnobody，可以在此处自行设定；  
anongid：匿名用户的GID值。  
```


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


helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
$ helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=172.29.50.28 \
    --set nfs.path=/data/nfs
