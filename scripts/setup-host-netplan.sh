cat /etc/netplan/50-cloud-init.yaml
# This file is generated from information provided by
# the datasource.  Changes to it will not persist across an instance.
# To disable cloud-init's network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    ethernets:
        eno1:
            addresses:
            - 172.29.40.27/24
            gateway4: 172.29.40.1
            nameservers:
                addresses:
                - 219.148.204.66
        ens1f1:
            addresses:
            - 172.29.50.27/24
            gateway4: 172.29.50.1
            nameservers:
                addresses:
                - 219.148.204.66
    bridges:
        br0:
            interfaces: [ens1f1]
            dhcp4: no
            addresses: [172.29.50.30/24]
            gateway4: 172.29.50.1
            nameservers:
                addresses:
                - 219.148.204.66
    version: 2