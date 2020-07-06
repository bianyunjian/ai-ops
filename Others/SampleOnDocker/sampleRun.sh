
# -d 表示在后台启动
# -p 9090:9090 表示将容器的端口 映射成宿主主机的端口，否则9090端口访问不到  hostPort:containerPort
# -v /usr/springboot-1.jar:/usr/springboot-1.jar 表示将宿主主机的jar文件，映射到容器中（分号前为宿主主机的路径，分号后为容器中的路径）
# --name springboot 表示为该容器取一个全局唯一的名称
# java:8 表示使用的镜像文件的名称和tag
# java -jar /usr/springboot-1.jar 表示运行jar包，注意：这里的jar包为容器中的位置，是通过前面的-v属性映射的
docker run -d -p 9090:9000 -v /home/byj/Project/k8sStudy/k3s-deploy/sample-docker-image/central-server-0.0.1-SNAPSHOT.jar:/usr/springboot.jar --name springboot4sampleApp java:8 java -jar /usr/springboot.jar



docker ps -a |grep springboot


echo 'you can access the doc address: http://localhost:9090/swagger-ui/index.html'
