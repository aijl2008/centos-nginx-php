```
docker build -t aijl2008/centos-nginx-php:7.1.30 .
```

```
docker run --rm -it -p 80:80 aijl2008/centos-nginx-php:7.1.30
docker run -d --name centos-nginx-php -p 80:80 aijl2008/centos-nginx-php:7.1.30
```