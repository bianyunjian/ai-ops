
#工作节点上的 docker镜像

sudo docker load -i  rancher-pause-3.1.tar 

sudo docker tag `sudo docker images |grep none  |awk {'print $3'}`  rancher/pause:3.1


sudo docker load -i  rancher-klipper-lb-v0.1.2.tar 

sudo docker tag `sudo docker images |grep none  |awk {'print $3'}`   rancher/klipper-lb:v0.1.2



