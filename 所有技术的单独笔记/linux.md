# -------------Linux--------------

## centos 7 的使用

## 1、安装

选择安装GUI图形页面

## 2、快捷键的设置

在右上角选择设置，搜索keyborad 添加快捷键，快捷键命令：/usr/bin/gnome-terminal  

此处自定义为ctrl + D

## 3、输入法的设置

如果安装了汉语的源，那只需要切换到pinyin的源就ok了 快捷键是 widows（super）+ 空格

## 4、常用的linux命令

| # cp a.txt /usr        | 拷贝文件到指定目录         |
| ---------------------- | -------------------------- |
| # mv  a.txt  /usr/java | 剪切（移动）文件到指定目录 |
|                        |                            |
|                        |                            |
|                        |                            |
|                        |                            |
|                        |                            |
|                        |                            |
|                        |                            |
|                        |                            |

## 5、安装 Java 项目部署环境

#### （1）安装 jdk

用rpm安装： #  rpm -i  rpm文件

####（2）安装 mysql

这里仅仅实验了yum 的安装方式：

1、[root@localhost ~]# wget -i -c http://dev.mysql.com/get/mysql57-community-release-el7-10.noarch.rpm 

2、[root@localhost ~]# yum -y install mysql57-community-release-el7-10.noarch.rpm

3、[root@localhost ~]# yum -y install mysql-community-server

4、至此，已经安装好了 mysql 覆盖掉了之前的mariadb

5、启动mysql服务：[root@localhost ~]# systemctl start  mysqld.service

6、查看服务状态：[root@localhost ~]# systemctl status mysqld.service

7、这里我们查看mysql的默认登录密码：[root@localhost ~]# grep "password" /var/log/mysqld.log

8、登陆上去后，先修改密码才能进行操作，设置密码又复杂度要求哦~：mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'An1942!';

9、为了防止 yum 更新而导致的mysql 更新，我们卸载掉 ：[root@localhost ~]# yum -y remove mysql57-community-release-el7-10.noarch

## 6、遇到的一些问题

### （1）yum源正在被占用

1、如果不是自己的操作，可以直接干掉那个进程

2、使用命令：  #   rm -f /var/run/yum.pid     干掉进程

### （2）修改 yum 源为 aliyun 的源



### （3）CentOS 7 的防火墙设置

1、开/关  防火墙：#   systemctl start / stop  firewalld  查看防火墙状态：#    systemctl status firewalld  

2、查看防火墙开放的所有端口：#   firewall--cmd --list-ports

3、开启某一端口： #   firewall-cmd --zone=public --add-port=80/tcp --permanent    （--permanent永久生效，没有此参数重启后失效） 

4、开启完成后并未生效，需要重启防火墙  命令：#   firewall-cmd --reload