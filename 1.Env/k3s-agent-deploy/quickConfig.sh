#!/bin/bash
#判断当前登录的用户是否为root
user=$(env | grep USER | cut -d "=" -f 2)
echo $user
if [ $user = "root"  ]
  then
    echo "当前用户是root"
  else
    echo "当前用户不是root，请先切换到root用户下, 然后执行 bash quickConfig.sh"
    exit
fi

echo '输入中心服务器的ip（必填项）:'
read -t 999 CENTRAL_SERVER_IP
echo "中心服务器的ip:$CENTRAL_SERVER_IP"

echo '输入中心服务器的秘钥Token（必填项）:'
read -t 999 CENTRAL_SERVER_TOKEN
echo "中心服务器的秘钥Token:$CENTRAL_SERVER_TOKEN"

echo '输入本机的机器名（可选项）'
read -t 999 LOCAL_HOST_NAME
echo "本机的机器名:$LOCAL_HOST_NAME"


if [ "$LOCAL_HOST_NAME" = ""  ]
  then
    echo "无须修改HOST_NAME"
  else
    echo  "#######################修改HOST_NAME"
    hostnamectl set-hostname $LOCAL_HOST_NAME
    hostnamectl status
    # 设置 hostname 解析
    echo "127.0.0.1   $(hostname)" >> /etc/hosts
    cat /etc/hosts
    echo "#######################修改HOST_NAME完成"
fi

echo "################### 设置时间同步的定时任务"
# 每分钟同步一次时间（中心服务器作为时间服务器）
echo "* * * * * /usr/sbin/ntpdate -u $CENTRAL_SERVER_IP >>/var/log/crontab.log 2>&1" >> /var/spool/cron/crontabs/root

#每分钟同步一次时间 （备选方案 NTP服务器(上海)）
echo "* * * * * /usr/sbin/ntpdate -u ntp.api.bz >>/var/log/crontab.log 2>&1" >> /var/spool/cron/crontabs/root
cat /var/spool/cron/crontabs/root
echo "################### 设置时间同步的定时任务完成"



echo "################### 更新k3s服务"

#卸载脚本
sh /usr/local/bin/k3s-uninstall.sh
sh /usr/local/bin/k3s-agent-uninstall.sh

cp k3s-arm64 /usr/local/bin/k3s -rf
chmod +x /usr/local/bin/k3s
export INSTALL_K3S_SKIP_DOWNLOAD=true
export K3S_URL=https://$CENTRAL_SERVER_IP:6443
export K3S_TOKEN=$CENTRAL_SERVER_TOKEN

export INSTALL_K3S_EXEC="--docker --no-deploy traefik"
sh k3s_install.sh
	

echo "################### 更新k3s服务完成"



echo "################### 更新docker私有化镜像地址"
cp /etc/docker/daemon.json /etc/docker/daemon.json.save
echo '' > /etc/docker/daemon.json
echo '{' >> /etc/docker/daemon.json
echo ' "default-runtime": "nvidia",' >> /etc/docker/daemon.json
echo ' "runtimes": {' >> /etc/docker/daemon.json
echo '  "nvidia": {' >> /etc/docker/daemon.json
echo '   "path": "nvidia-container-runtime",' >> /etc/docker/daemon.json
echo '   "runtimeArgs": []' >> /etc/docker/daemon.json
echo '  }' >> /etc/docker/daemon.json
echo ' },' >> /etc/docker/daemon.json
echo " \"insecure-registries\": [\"$CENTRAL_SERVER_IP:10080\"]" >> /etc/docker/daemon.json
echo '}' >> /etc/docker/daemon.json

cat /etc/docker/daemon.json
echo "################### 更新docker私有化镜像地址完成"


#保存退出，执行命令重新加载新的服务配置文件:
systemctl daemon-reload
systemctl restart docker
systemctl restart k3s-agent.service


echo "#################检查环境设置"
docker version

systemctl status k3s-agent.service


