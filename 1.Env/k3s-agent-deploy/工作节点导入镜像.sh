
#工作节点上的 docker镜像

sudo docker load -i  rancher-pause-3.1.tar 

sudo docker tag 6cf7c80fe444 rancher/pause:3.1


sudo docker load -i  rancher-klipper-lb-v0.1.2.tar 

sudo docker tag 9be4f056f04b  rancher/klipper-lb:v0.1.2



