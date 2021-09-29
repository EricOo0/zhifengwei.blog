# docker命令
launchctl list|grep docker --查看启动的服务  
docker images --查看本地有哪些镜像
docker ps -a  --列出所有容器包括已经停止的
docker stop container_id -- 停止容器
docker start container_id --开启容器 需要交互的话加上-i
docker exec -it 容器id /bin/bash --进入容器
docker pull * --下载镜像（docker pull ubuntu:13.10 带版本的下载）
docker info --查看docker信息
docker logs -f 容器ID（-f：可以滚动查看日志的最后几行） --查看容器log
docker run -i -t -v 镜像id /bin/bash --创建容器
docker rmi 镜像名/镜像id --删除镜像
docker rm containerid --删除容器
docker build go_docker:v1--打包镜像
docker run -ti -p 80:80 -name=go_server imageid /bin/bash --创建容器并指定host80和容器80的端口映射，设置容器别名
docker commit -m "信息" 容器id/容器名 镜像名
# dockfile
copy 
add