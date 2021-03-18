FROM ubuntu:20.04
RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list && \
apt clean && \
apt update && \
DEBIAN_FRONTEND=noninteractive TZ="Asia/Shanghai" apt install -y \
git ca-certificates \
vim jq less bash-completion unzip sysstat ssh bat gawk grep sed \
net-tools iputils-ping iproute2 dnsutils \
iperf3 qperf \
curl wget 