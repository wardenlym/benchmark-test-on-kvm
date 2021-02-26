ubuntu@node01:~$ cat /etc/netplan/00-installer-config.yaml
# This is the network config written by 'subiquity'
network:
  ethernets:
    enp1s0:
      addresses:
      - 192.168.122.31/24
      gateway4: 192.168.122.1
      nameservers:
        addresses:
        - 114.114.114.114
        search: []
    enp6s0:
      addresses:
      - 172.29.50.31/24
      routes:
          - to: 172.29.50.0/24
            via: 172.29.50.30
      gateway4: 172.29.50.27
      nameservers:
        addresses:
        - 219.148.204.66
        search: []
  version: 2