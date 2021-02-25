sudo cat /etc/netplan/00-installer-config.yaml
# This is the network config written by 'subiquity'
network:
  ethernets:
    eth0:
      dhcp-identifier: mac
      dhcp4: true
      dhcp-identifier: mac
    eth1:
      dhcp4: no
      addresses:
      - 172.29.50.31/24
      routes:
          - to: 172.29.50.0/24
            via: 172.29.50.30
      nameservers:
          addresses:
          - 219.148.204.66
  version: 2