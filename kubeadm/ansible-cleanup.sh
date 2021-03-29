#!/usr/bin/env bash


ansible -i hosts cluster -m shell -a 'cat /sys/class/dmi/id/product_uuid' --become 

ansible -i hosts cluster -m shell -a 'docker ps -a -q | xargs docker rm -f' --become
ansible -i hosts cluster -m shell -a 'docker volume rm $(docker volume ls -q)' --become
ansible -i hosts cluster -m shell -a 'ip link del flannel.1' --become

ansible -i hosts cluster -m shell -a 'rm -rf /var/lib/etcd' --become
ansible -i hosts cluster -m shell -a 'rm -rf /etc/kubernetes' --become
ansible -i hosts cluster -m shell -a 'rm -rf /etc/cni' --become
ansible -i hosts cluster -m shell -a 'rm -rf /opt/cni' --become
ansible -i hosts cluster -m shell -a 'rm -rf /var/lib/cni' --become
ansible -i hosts cluster -m shell -a 'rm -rf /var/run/calico' --become

ansible -i hosts cluster -m shell -a 'ls /var/lib/etcd' --become
ansible -i hosts cluster -m shell -a 'ls /etc/kubernetes' --become
ansible -i hosts cluster -m shell -a 'ls /etc/cni' --become
ansible -i hosts cluster -m shell -a 'ls /opt/cni' --become
ansible -i hosts cluster -m shell -a 'ls /var/lib/cni' --become
ansible -i hosts cluster -m shell -a 'ls /var/run/calico' --become

ansible -i hosts cluster -m shell -a 'iptables -t filter -F && iptables -t filter -X && systemctl restart docker' --become
 
 
iptables -t filter -F && iptables -t filter -X && systemctl restart docker

ls /var/lib/etcd
ls /etc/kubernetes
ls /etc/cni
ls /opt/cni
ls /var/lib/cni
ls /var/run/calico

docker ps -a -q | xargs docker rm -f
docker volume rm $(docker volume ls -q)
rm -rf /var/lib/etcd
rm -rf /etc/kubernetes
rm -rf /etc/cni
rm -rf /opt/cni
rm -rf /var/lib/cni
rm -rf /var/run/calico

