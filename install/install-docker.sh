sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
#apt-cache madison docker-ce
sudo apt install docker-ce=5:19.03.15~3-0~ubuntu-focal docker-ce-cli=5:19.03.15~3-0~ubuntu-focal containerd.io
sudo apt-mark hold docker-ce
sudo usermod -aG docker $USER



# Remove Docker

# docker container stop $(docker container ls -aq)
# docker system prune -a --volumes
# sudo apt purge docker-ce docker-ce-cli 
# sudo apt autoremove

sudo bash -c 'cat > /etc/docker/daemon.json <<EOF
{
  "registry-mirrors": [
      "https://registry.docker-cn.com",
      "http://hub-mirror.c.163.com",
      "https://v2qkv589.mirror.aliyuncs.com",
      "https://mirror.ccs.tencentyun.com",
      "https://docker.mirrors.ustc.edu.cn",
      "http://f1361db2.m.daocloud.io"
  ],
  "live-restore": true ,
  "max-concurrent-downloads": 10,
  "log-driver": "json-file",
  "log-level": "warn",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "data-root": "/data/docker",
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF'

sudo systemctl restart docker.service
