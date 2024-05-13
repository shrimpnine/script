#!/bin/bash

IFS=$'\n'
_docker_run_dir="/home/shrimp/docker_conf/docker_run" #运行重启docker容器的脚本文件夹

sudo docker images | grep -v REPOSITORY | awk '{print $1}' | sudo xargs -L1 docker pull #更新所有镜像

#sudo docker ps -a | grep -v CONTAINER | awk '{print $2}' | #删除所有旧版本的容器

for i in `sudo docker ps -a | grep -v CONTAINER`
do
	_image=`echo $i | awk '{print $2}' | grep -v :latest` #获取镜像ID
	if [[ $_image ]] ;then
		echo "镜像ID: $_image"

		_containerID=`echo $i | awk '{print $1}'` #获取容器ID
		echo "容器ID: $_containerID"

		_containerName=`sudo docker inspect --format='{{.Name}}' $_containerID`
		_containerName=${_containerName##*/}
		echo "容器name: $_containerName" #获取镜像名字

		sudo docker stop $_containerName #停止所有不是latest的容器
		sudo docker rm $_containerName #删除所有不是latest的容器
		_dockerRunScript=$_docker_run_dir/$_containerName.sh
		echo "容器run脚本: $_dockerRunScript" #重启docker的脚本
		bash $_dockerRunScript
	fi
done

for i in `sudo docker images | grep "<none>" | awk '{print $3}'`
do
	if [[ $i ]] ; then #IMAGE ID
		sudo docker rmi $i #清理更新后<none>的镜像
	fi
done
