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

| 命令                     | 描述                                                         |
| ------------------------ | ------------------------------------------------------------ |
| mv  a.txt  /usr/java     | 剪切（移动）文件到指定目录（-i 覆盖文件前提示）              |
| rm  a.txt                | 删除文件（不可恢复），删除文件夹加上 -r                      |
| touch  a.txt             | 创建文件                                                     |
| cp a.txt  /home/an       | 拷贝文件到指定目录                                           |
| cat 和 more              | 都可以查看文件                                               |
| echo  内容   >  a.txt    | 输出指定内容到终端，也可以重定向内容到指定文件( >>是追加内容 ) |
| shutdown -r  now         | 立即重启                                                     |
| shutdown now             | 立即关机                                                     |
| shutdown 20:35           | 指定关机时间                                                 |
| tar zxvf FileName.tar.gz | 解压  tar.gz 文件                                            |
| unzip FileName.zip       | 解压 .zip 文件                                               |
|                          |                                                              |
|                          |                                                              |
|                          |                                                              |
|                          |                                                              |
|                          |                                                              |
|                          |                                                              |
|                          |                                                              |
|                          |                                                              |

### （1）常用的解压命令

1、.tar 用 tar –xvf 解压

2、.gz 用 gzip -d或者gunzip 解压

 3、.tar.gz和.tgz 用 tar –xzf 解压 

4、.bz2 用 bzip2 -d或者用bunzip2 解压

5、.tar.bz2用 tar –xjf 解压

6、*.Z 用 uncompress 解压 

7、.tar.Z 用tar –xZf 解压

8、*.rar 用 unrar e解压 

9、.zip 用 unzip 解压

## 5、安装 Java 项目部署环境

###（1）安装 jdk

用rpm安装： #  rpm -i  rpm文件

###（2）安装 mysql

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

1、wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

2、yum clean all

3、yum makecache

### （3）CentOS 7 的防火墙设置

1、开/关  防火墙：#   systemctl start / stop  firewalld  查看防火墙状态：#    systemctl status firewalld  

2、查看防火墙开放的所有端口：#   firewall--cmd --list-ports

3、开启某一端口： #   firewall-cmd --permanent --zone=public --add-port=80/tcp    （--permanent永久生效，没有此参数重启后失效） 

4、开启完成后并未生效，需要重启防火墙  命令：#   firewall-cmd --reload



### （4）centos的端口占用情况

netstat -ntlp //查看当前所有tcp端口· 
netstat -ntulp |grep 80 //查看所有80端口使用情况· 
netstat -an | grep 3306 //查看所有3306端口使用情况·

## 7、数据库连接的问题

首先要远程连接数据库，需要mysql开启远程权限。

设置如下：

**use mysql;**

**update user set host = '%' where user = 'root';**

**这样在远端就可以通过root用户访问Mysql.**

 ## 8、nginx的使用

### （1）安装编译工具及库文件

```
yum -y install make zlib zlib-devel gcc-c++ libtool  openssl openssl-devel
```

### （2）首先要安装 PCRE

PCRE 作用是让 Nginx 支持 Rewrite 功能。

1、下载 PCRE 安装包，下载地址： http://downloads.sourceforge.net/project/pcre/pcre/8.35/pcre-8.35.tar.gz

```
[root@bogon src]# cd /usr/local/src/
[root@bogon src]# wget http://downloads.sourceforge.net/project/pcre/pcre/8.35/pcre-8.35.tar.gz
```

![img](https://www.runoob.com/wp-content/uploads/2015/01/nginx1.png)

```
[root@bogon src]# tar zxvf pcre-8.35.tar.gz
```

3、进入安装包目录

```
[root@bogon src]# cd pcre-8.35
```

4、编译安装 

```
[root@bogon pcre-8.35]# ./configure
[root@bogon pcre-8.35]# make && make install
```

5、查看pcre版本

```
[root@bogon pcre-8.35]# pcre-config --version
```

![img](https://www.runoob.com/wp-content/uploads/2015/01/nginx2.png)

1、下载 Nginx，下载地址：http://nginx.org/download/nginx-1.6.2.tar.gz

```
[root@bogon src]# cd /usr/local/src/
[root@bogon src]# wget http://nginx.org/download/nginx-1.6.2.tar.gz
```

![img](https://www.runoob.com/wp-content/uploads/2015/01/nginx3.png) 2、解压安装包

```
[root@bogon src]# tar zxvf nginx-1.6.2.tar.gz
```

3、进入安装包目录

```
[root@bogon src]# cd nginx-1.6.2
```

4、编译安装

```
[root@bogon nginx-1.6.2]# ./configure --prefix=/usr/local/webserver/nginx --with-http_stub_status_module --with-http_ssl_module --with-pcre=/usr/local/src/pcre-8.35
[root@bogon nginx-1.6.2]# make
[root@bogon nginx-1.6.2]# make install
```

5、查看nginx版本

```
[root@bogon nginx-1.6.2]# /usr/local/webserver/nginx/sbin/nginx -v
```

![img](https://www.runoob.com/wp-content/uploads/2015/01/nginx4.png)

### Nginx 配置

创建 Nginx 运行使用的用户 www：

```
[root@bogon conf]# /usr/sbin/groupadd www 
[root@bogon conf]# /usr/sbin/useradd -g www www
```

配置nginx.conf ，将/usr/local/webserver/nginx/conf/nginx.conf替换为以下内容



```
[root@bogon conf]#  cat /usr/local/webserver/nginx/conf/nginx.conf

user www www;
worker_processes 2; #设置值和CPU核心数一致
error_log /usr/local/webserver/nginx/logs/nginx_error.log crit; #日志位置和日志级别
pid /usr/local/webserver/nginx/nginx.pid;
#Specifies the value for maximum file descriptors that can be opened by this process.
worker_rlimit_nofile 65535;
events
{
  use epoll;
  worker_connections 65535;
}
http
{
  include mime.types;
  default_type application/octet-stream;
  log_format main  '$remote_addr - $remote_user [$time_local] "$request" '
               '$status $body_bytes_sent "$http_referer" '
               '"$http_user_agent" $http_x_forwarded_for';
  
#charset gb2312;
     
  server_names_hash_bucket_size 128;
  client_header_buffer_size 32k;
  large_client_header_buffers 4 32k;
  client_max_body_size 8m;
     
  sendfile on;
  tcp_nopush on;
  keepalive_timeout 60;
  tcp_nodelay on;
  fastcgi_connect_timeout 300;
  fastcgi_send_timeout 300;
  fastcgi_read_timeout 300;
  fastcgi_buffer_size 64k;
  fastcgi_buffers 4 64k;
  fastcgi_busy_buffers_size 128k;
  fastcgi_temp_file_write_size 128k;
  gzip on; 
  gzip_min_length 1k;
  gzip_buffers 4 16k;
  gzip_http_version 1.0;
  gzip_comp_level 2;
  gzip_types text/plain application/x-javascript text/css application/xml;
  gzip_vary on;
 
  #limit_zone crawler $binary_remote_addr 10m;
 #下面是server虚拟主机的配置
 server
  {
    listen 80;#监听端口
    server_name localhost;#域名
    index index.html index.htm index.php;
    root /usr/local/webserver/nginx/html;#站点目录
      location ~ .*\.(php|php5)?$
    {
      #fastcgi_pass unix:/tmp/php-cgi.sock;
      fastcgi_pass 127.0.0.1:9000;
      fastcgi_index index.php;
      include fastcgi.conf;
    }
    location ~ .*\.(gif|jpg|jpeg|png|bmp|swf|ico)$
    {
      expires 30d;
  # access_log off;
    }
    location ~ .*\.(js|css)?$
    {
      expires 15d;
   # access_log off;
    }
    access_log off;
  }

}
```

检查配置文件nginx.conf的正确性命令：

```
[root@bogon conf]# /usr/local/webserver/nginx/sbin/nginx -t
```

![img](https://www.runoob.com/wp-content/uploads/2015/01/nginx5.png)

### 启动 Nginx

Nginx 启动命令如下：

```
[root@bogon conf]# /usr/local/webserver/nginx/sbin/nginx
```

![img](https://www.runoob.com/wp-content/uploads/2015/01/nginx6.png)

### 访问站点

从浏览器访问我们配置的站点ip：

![img](https://www.runoob.com/wp-content/uploads/2015/01/nginx7.png)

### Nginx 其他命令

以下包含了 Nginx 常用的几个命令：

```
/usr/local/webserver/nginx/sbin/nginx -s reload            # 重新载入配置文件
/usr/local/webserver/nginx/sbin/nginx -s reopen            # 重启 Nginx
/usr/local/webserver/nginx/sbin/nginx -s stop              # 停止 Nginx
```