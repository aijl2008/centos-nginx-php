```
docker build -t docker.artron.net/centos-nginx-php:7.1.30 .
```

```
docker run -d --name centos-nginx-php -p 80:80 docker.artron.net/centos-nginx-php:7.1.30
```