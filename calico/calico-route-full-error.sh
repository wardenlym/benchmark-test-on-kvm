calico的子网26=64个pod
大量建pod时报错：

Error adding test-br1vgo-1_latency-deployment-128-9c7d555db-z5vzn/97905c395f37e6359a845a0cbe5066c8ed44eb349edddd8788a850f52af2fd4b to network calico/k8s-pod-network: error adding host side routes for interface: cali37fa4caaf94, error: route (Ifindex: 1458, Dst: 10.44.182.230/32, Scope: 253) already exists for an interface other than 'cali37fa4caaf94'

待查
