#!/usr/bin/env bash

#read ip address location
source ../.env

#Network
docker network create --gateway=192.168.99.1 --subnet=192.168.99.0/24 netkudo
sleep 2

#management container
#=====================
docker pull portainer
sleep 10
docker run --name portainer \
d -v /var/run/docker.sock:/var/run/docker.sock \
--net netkudo \
--ip 192.168.99.111 \
-p 9000:9000 portainer/portainer
sleep5

##nginx
#======
docker pull nginx
sleep 10
docker run --name mynginx -d -p 80:80 \
--net netkudo \
--ip $WEB_TARGET_MACHINE nginx
sleep 2
curl http://localhost:80


#MariaDB
#========
docker pull mariadb
sleep 10
docker run --name=mariadb-data -v /var/lib/mysql mariadb true
sleep 5

#mariadb engine
docker run --name=mariadb -d -p 3306:3306 \
--net netkudo \
--ip $DATABASE_TARGET_MACHINE \
--volumes-from=mariadb-data \
-e MYSQL_ROOT_PASSWORD=root mariadb
sleep 5

#Radis
#======
docker run --name some-redis -d \
--net netkudo \
--ip $CACHE_TARGET_MACHINE redis

mkdir myapp
cd myapp
npm init
npm install express --save




echo 'Running'
