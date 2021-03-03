sudo swapoff -a
sudo sed -i '/swap/s/^\(.*\)$/#\1/g' /etc/fstab

modprobe -- ip_vs
modprobe -- ip_vs_rr
modprobe -- ip_vs_wrr
modprobe -- ip_vs_sh
modprobe -- br_netfilter

for module in br_netfilter ip6_udp_tunnel ip_set ip_set_hash_ip ip_set_hash_net iptable_filter iptable_nat iptable_mangle iptable_raw nf_conntrack_netlink nf_conntrack nf_conntrack_ipv4   nf_defrag_ipv4 nf_nat nf_nat_ipv4 nf_nat_masquerade_ipv4 nfnetlink udp_tunnel veth vxlan x_tables xt_addrtype xt_conntrack xt_comment xt_mark xt_multiport xt_nat xt_recent xt_set  xt_statistic xt_tcpudp; do
    if ! lsmod | grep -q $module; then
        echo "module $module is not present, try to install...";
                modprobe $module
                if [ $? -eq 0 ]; then
                        echo -e "\033[32;1mSuccessfully installed $module!\033[0m"
                else
                        echo -e "\033[31;1mInstall $module failed!!!\033[0m"
                fi
        fi;
done


# https://zhuanlan.zhihu.com/p/138554103
# https://blog.csdn.net/engchina/article/details/103331510
# calico: rp_filter=1
# ubuntu20.04 default is 2