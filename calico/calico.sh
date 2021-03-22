calico在多网卡情况下指定选择网络接口


// calico.yaml 文件修改配置如下 
// calico在多网卡情况下指定选择网络接口            
            - name: IP_AUTODETECTION_METHOD
              value: "interface=ens8" # ens 根据实际网卡开头配置
            - name: IP_AUTODETECTION_METHOD
              value: "interface=ens8" # ens 根据实际网卡开头配置
              #支持通配 value: "interface=ens.*"
            # Auto-detect the BGP IP address.
            - name: IP
              value: "autodetect"
            # Enable IPIP
            - name: CALICO_IPV4POOL_IPIP
              value: "Never"          # 禁止IPIP加密，否则性能会很慢

