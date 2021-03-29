 正确的放
 
       /etc/modules-load.d/bridge.conf:

           br_netfilter

       /etc/sysctl.d/bridge.conf:

           net.bridge.bridge-nf-call-ip6tables = 0
           net.bridge.bridge-nf-call-iptables = 0
           net.bridge.bridge-nf-call-arptables = 0
