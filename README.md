```
docker build -t docker.artron.net/centos-nginx-php .
```

```
docker run -it -p 8099:80 \
-v /data/code/192.168.64.104_8004/micro-service-example/member-php:/data/webroot \
docker.artron.net/centos-nginx-php /bin/bash
```