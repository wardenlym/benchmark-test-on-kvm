0.各个机器进行时间校对。

1.修改各个主机名

1、方法一使用hostnamectl命令
[root@xlucas1 ~]# hostnamectl set-hostname xlucas2
 
2、方法二：修改配置文件 /etc/hostname 保存退出
[root@xlucas1 ~]# vi /etc/hostname
xlucas2

2.利用ssh实现各个机器之间的免密登陆。
https://blog.csdn.net/yujia_666/article/details/83307968
3.修改各个机器的hosts文件如下：（各个服务器之间都要进行配置）

一台机器上修改好，用scp在各个机器之间进行传输：