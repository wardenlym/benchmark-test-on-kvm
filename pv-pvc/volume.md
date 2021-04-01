卷的类型很多，但是大多是跟云服务绑定有关的。类似gce/aws/azure独有的存储后端。

我总结感觉比较有用的是下面几个：

#### emptyDir
当 Pod 被分配给节点时，首先创建 emptyDir 卷，并且只要该 Pod 在该节点上运行，该卷就会存在。正如卷的名字所述，它最初是空的。Pod 中的容器可以读取和写入 emptyDir 卷中的相同文件，尽管该卷可以挂载到每个容器中的相同或不同路径上。当出于任何原因从节点中删除 Pod 时，emptyDir 中的数据将被永久删除。

注意：容器崩溃不会从节点中移除 pod，因此 emptyDir 卷中的数据在容器崩溃时是安全的。

emptyDir 的用法有：

暂存空间，例如用于基于磁盘的合并排序
用作长时间计算崩溃恢复时的检查点
Web服务器容器提供数据时，保存内容管理器容器提取的文件

适合做一般性的缓存目录，记录一些私有的状态之类的。

Pod 示例
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pd
spec:
  containers:
  - image: k8s.gcr.io/test-webserver
    name: test-container
    volumeMounts:
    - mountPath: /cache
      name: cache-volume
  volumes:
  - name: cache-volume
    emptyDir: {}
```

#### hostPath

hostPath 卷将主机节点的文件系统中的文件或目录挂载到集群中。该功能大多数 Pod 都用不到，但是一些维护集群功能的daemonset都用到了hostPath，比如网络插件，会使用hostPath卷将容器里的数据拷贝到节点上。

用来做Pod和主机目录之间的文件交换（注意Pod需要对应权限提权。）

例如，hostPath 的用途如下：

- 运行需要访问 Docker 内部的容器；使用 /var/lib/docker 的 hostPath
- 在容器中运行 cAdvisor；使用 /dev/cgroups 的 hostPath
- 允许 pod 指定给定的 hostPath 是否应该在 pod 运行之前存在，是否应该创建，以及它应该以什么形式存在

type 字段支持以下值：

```
值	行为
空字符串（默认）用于向后兼容，这意味着在挂载 hostPath 卷之前不会执行任何检查。
DirectoryOrCreate	如果在给定的路径上没有任何东西存在，那么将根据需要在那里创建一个空目录，权限设置为 0755，与 Kubelet 具有相同的组和所有权。
Directory	给定的路径下必须存在目录
FileOrCreate	如果在给定的路径上没有任何东西存在，那么会根据需要创建一个空文件，权限设置为 0644，与 Kubelet 具有相同的组和所有权。
File	给定的路径下必须存在文件
Socket	给定的路径下必须存在 UNIX 套接字
CharDevice	给定的路径下必须存在字符设备
BlockDevice	给定的路径下必须存在块设备
```

DirectoryOrCreate 比较常用，相当于做mkdir -p
File/FileOrCreate Pod必须要的文件可以用来检查。

使用这种卷类型是请注意，因为：

由于每个节点上的文件都不同，具有相同配置（例如从 podTemplate 创建的）的 pod 在不同节点上的行为可能会有所不同
当 Kubernetes 按照计划添加资源感知调度时，将无法考虑 hostPath 使用的资源
在底层主机上创建的文件或目录只能由 root 写入。您需要在特权容器中以 root 身份运行进程，或修改主机上的文件权限以便写入 hostPath 卷

Pod 示例
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pd
spec:
  containers:
  - image: k8s.gcr.io/test-webserver
    name: test-container
    volumeMounts:
    - mountPath: /test-pd
      name: test-volume
  volumes:
  - name: test-volume
    hostPath:
      # directory location on host
      path: /data
      # this field is optional
      type: Directory
```

#### nfs

比较通用，在不考虑用高级的CSI如ceph可以用，用起来跟一般的nfs差不多,NFS本身也不是可靠的，但是具备了PV/PVC的基础要求。
nfs 卷允许将现有的 NFS（网络文件系统）共享挂载到您的容器中。不像 emptyDir，当删除 Pod 时，nfs 卷的内容被保留，卷仅仅是被卸载。这意味着 NFS 卷可以预填充数据，并且可以在 pod 之间“切换”数据。 NFS 可以被多个写入者同时挂载。

官方支持的示例比较多： https://github.com/kubernetes/examples/tree/master/staging/volumes/nfs


#### subPath 的目的是为了在单一Pod中多次使用同一个volume而设计的

例如，像下面的LAMP，可以将同一个volume下的 mysql 和 html目录，挂载到不同的挂载点上，这样就不需要为 mysql 和 html 单独创建volume了。
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-lamp-site
spec:
    containers:
    - name: mysql
      image: mysql
      env:
      - name: MYSQL_ROOT_PASSWORD
        value: "rootpasswd" 
      volumeMounts:
      - mountPath: /var/lib/mysql
        name: site-data
        subPath: mysql
    - name: php
      image: php:7.0-apache
      volumeMounts:
      - mountPath: /var/www/html
        name: site-data
        subPath: html
    volumes:
    - name: site-data
      persistentVolumeClaim:
        claimName: my-lamp-site-data
```
