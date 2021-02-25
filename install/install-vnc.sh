# https://xie.infoq.cn/article/cf473dc0dea917b0b2a546ecd


sudo apt install -y xfce4 xfce4-goodies xorg dbus-x11 x11-xserver-utils
sudo apt install -y tigervnc-standalone-server tigervnc-common

# Next, run the vncserver command to set a VNC access password, create the initial configuration files, and start a VNC server instance:
vncserver

# Note that if you ever want to change your password or add a view-only password, you can do so with the vncpasswd command:
vncpasswd

# configure
vim ~/.vnc/xstartup
# #!/bin/sh
# unset SESSION_MANAGER
# unset DBUS_SESSION_BUS_ADDRESS
# exec startxfce4 
chmod u+x ~/.vnc/xstartup

vim ~/.vnc/config
# geometry=1920x1084
# dpi=96

sudo vim /etc/systemd/system/vncserver@.service
# modify line 7 username

# [Unit]
# Description=Remote desktop service (VNC)
# After=syslog.target network.target
#
# [Service]
# Type=simple
# User=username
# PAMName=login
# PIDFile=/home/%u/.vnc/%H%i.pid
# ExecStartPre=/bin/sh -c '/usr/bin/vncserver -kill :%i > /dev/null 2>&1 || :'
# ExecStart=/usr/bin/vncserver -localhost no :%i -geometry 1440x900 -alwaysshared -fg
# ExecStop=/usr/bin/vncserver -kill :%i
#
# [Install]
# WantedBy=multi-user.target


# TigerVNC by default listens only on the loopback network interface. This is good for security, so that only you on the very same computer can connect.
# https://askubuntu.com/questions/1254101/vnc-server-is-accessible-only-for-localhost

# 1. When you start the server from the command line, add -localhost no to the command line.
# 2. Configure TigerVNC to permanently listen to all network interfaces in /etc/vnc.conf. Add the following. 
# $localhost = "no";

sudo systemctl daemon-reload
sudo systemctl enable vncserver@1.service
sudo systemctl start vncserver@1.service
sudo systemctl status vncserver@1.service

# additional ssh
# ssh -L 5901:127.0.0.1:5901 -N -f -l username server_ip_address