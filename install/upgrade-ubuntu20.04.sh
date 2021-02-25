sudo apt update 
sudo apt dist-upgrade -y
sudo do-release-upgrade

# if see:
# this session appears to be running under ssh. it is not recommended to perform a upgrade over ssh currently because in case of failure it is harder to recover.
# check if 1022 open
# iptables -I INPUT -p tcp --dport 1022 -j ACCEPT
# if connection closed in installing, ssh via 1022 and screen attach

# ssh [email protected]_ip_address -p 1022
# screen -x


