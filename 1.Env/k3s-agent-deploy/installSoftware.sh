#!/bin/bash
#判断当前登录的用户是否为root
user=$(env | grep USER | cut -d "=" -f 2)
echo $user
if [ $user = "root"  ]
  then
    echo "当前用户是root"
  else
    echo "当前用户不是root，请先切换到root用户下, 然后执行 bash installSoftware.sh"
    exit
fi


echo "#####################环境准备,安装常用软件包"
cp /etc/apt/sources.list /etc/apt/sources.list.save -rf
cp sources.list /etc/apt/sources.list -rf
echo "##################### 添加Docker源到/etc/apt/sources.list"
echo "deb [arch=arm64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu $(lsb_release -cs) stable" >> /etc/apt/sources.list
#echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" >> /etc/apt/sources.list
echo "##################### 添加Docker GPG key"
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg | apt-key add -


apt update
apt install -y htop
apt install -y vim
apt install -y curl
apt install -y wget
apt install -y nfs-common
apt install -y ca-certificates

echo "#####################安装 Docker 环境" 
apt install -y docker-ce
echo "##################### Docker 安装完成，查看版本信息"
docker version 
  
 
  
echo "#####################导入镜像:"
cd docker-images
sh importDockerImages.sh

 
echo "##################### 设置系统时间与网络时间同步"
#安装ntpdate工具
systemctl  disable systemd-timesyncd.service
timedatectl set-timezone Asia/Shanghai
timedatectl set-ntp true
apt-get install ntpdate
hwclock --systohc
#每分钟同步一次时间 （备选方案 NTP服务器(上海)）
echo "* * * * * /usr/sbin/ntpdate -u ntp.api.bz >>/var/log/crontab.log 2>&1" >> /var/spool/cron/crontabs/root

#root文件的权限必须为600，否则会出现错误 INSECURE MODE (mode 0600 expected)
chmod 600 /var/spool/cron/crontabs/root
touch /var/log/crontab.log
chmod 777 /var/log/crontab.log
service cron restart
cat /var/log/cron.log
#cron.log默认的日志未打开， 需要打开
#vim /etc/rsyslog.d/50-default.conf

 
 
echo "#####################重新加载新的服务配置文件:"
systemctl daemon-reload
systemctl restart docker 

echo "#################检查环境设置"
docker version
echo "#################当前系统时间："
date


