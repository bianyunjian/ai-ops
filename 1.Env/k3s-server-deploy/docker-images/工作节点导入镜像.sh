
#服务节点上的 docker镜像

sudo docker load -i  rancher_pause_3.1.tar 
sudo docker tag `sudo docker images |grep none  |awk {'print $3'}`  rancher/pause:3.1


sudo docker load -i  rancher_klipper-lb_0.1.2.tar 
sudo docker tag `sudo docker images |grep none  |awk {'print $3'}`   rancher/klipper-lb:v0.1.2

sudo docker load -i  rancher_coredns-coredns_1.6.3.tar 
sudo docker tag `sudo docker images |grep none  |awk {'print $3'}`  rancher/coredns-coredns:1.6.3

sudo docker load -i  rancher_local-path-provisioner_0.0.11.tar 
sudo docker tag `sudo docker images |grep none  |awk {'print $3'}`   rancher/local-path-provisioner:v0.0.11

sudo docker load -i  rancher_mertrics-server_0.3.6.tar 
sudo docker tag `sudo docker images |grep none  |awk {'print $3'}`   rancher/metrics-server:v0.3.6

sudo docker load -i  rancher_library-traefik_1.7.19.tar 
sudo docker tag `sudo docker images |grep none  |awk {'print $3'}`   rancher/library-traefik:1.7.19

