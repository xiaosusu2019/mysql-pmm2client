# mysql-pmm2client

* 创建Image
`docker build -t mysql-pmm2Client .`


*  创建容器
```
docker run -d --name mysql-client \
           -v $(pwd)/conf.d:/etc/mysql/conf.d \
           -v $(pwd)/data:/var/lib/mysql \
           -e MYSQL_ROOT_PASSWORD="12345678" \
           -p 3320:3306 \
           --restart=always \
       mysql-pmm2Client

# 密码设置不生效,可以使用: mysqladmin -u root password "newpass"
```

-----

1.Docker安装PMM Server

```
docker create -v /opt/prometheus/data -v /opt/consul-data -v /var/lib/mysql -v /var/lib/grafana --name pmm-data percona/pmm-server:2 /bin/true

docker run -d -p 81:80 -p 443:443 --volumes-from pmm-data --name pmm-server --restart always percona/pmm-server:2

```


2、获取Docker中两个容器的IP地址
```
docker inspect --format='{{.NetworkSettings.IPAddress}}' pmm-server

docker inspect --format='{{.NetworkSettings.IPAddress}}' mysql-client
```


3、进入docker PMM Client 容器中,启动Client

```

cd /home/pmm2-client-2.10.1

Install
./install_tarball

Set Path
export PATH=/usr/local/percona/pmm2/bin:$PATH

Configure Agent.( 这里ip使用服务器IP)
/usr/local/percona/pmm2/bin/pmm-agent setup --config-file=/usr/local/percona/pmm2/config/pmm-agent.yaml --server-insecure-tls --server-address=172.17.0.3:443 --server-username=admin --server-password=admin

Start Agent
/usr/local/percona/pmm2/bin/pmm-agent --config-file=/usr/local/percona/pmm2/config/pmm-agent.yaml &

Add MySQL to pmm monitoring.(这里使用mysql容器IP)
/usr/local/percona/pmm2/bin/pmm-admin add mysql --environment=PROD --replication-set=repset-name --username=root --password=12345678 --query-source=perfschema 172.17.0.4:3306
