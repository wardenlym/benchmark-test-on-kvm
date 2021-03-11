calico在多网卡情况下指定选择网络接口


// calico.yaml 文件添加以下二行
            - name: IP_AUTODETECTION_METHOD
              value: "interface=ens8"  # ens 根据实际网卡开头配置
 
 // 配置如下             
            - name: CLUSTER_TYPE
              value: "k8s,bgp"
            - name: IP_AUTODETECTION_METHOD
              value: "interface=ens8"
              #支持通配 value: "interface=ens.*"
            # Auto-detect the BGP IP address.
            - name: IP
              value: "autodetect"
            # Enable IPIP
            - name: CALICO_IPV4POOL_IPIP
              value: "Always"
