#!/bin/bash 

echo "create a mysql container.."
docker run -d --name mysql-containerf \
           -v $(pwd)/conf.d:/etc/mysql/conf.d \
           -v $(pwd)/data:/var/lib/mysql \
           -e MYSQL_ROOT_PASSWORD="root" \
           -p 3322:3306 \
	   -p 10025:22 \
           --restart=always \
       mysql-serverf
