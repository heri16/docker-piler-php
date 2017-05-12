# docker-piler-php
Piler web ui as Docker image (http://mailpiler.org)

## Configure New Installation:
```bash
sudo mkdir /var/www/piler
sudo restorecon -Rv /usr/local/etc/piler /var/www/piler
ls -Z /usr/local/etc/piler /var/www/piler
docker run -ti --rm -v /usr/local/etc/piler/:/usr/local/etc/piler:ro -v /var/www/piler/:/var/www/piler:rw,z heri16/piler-php
# gather_webserver_data
# gather_mysql_account
# gather_smtp_relay_data
```

## Usage in docker-compose.yml:
```yaml
services:
  php_fpm:
    build: ./docker-piler-php
    links:
      - nginx_proxy
      - piler_indexer
    expose:
      - "9000"
    volumes:
      - /var/www/piler/:/var/www/piler:ro,z
      - /var/www/piler/tmp/:/var/www/piler/tmp:rw,Z
      - /usr/local/etc/piler/:/usr/local/etc/piler:ro
      - /var/piler/store/:/var/piler/store:ro,z
      - /var/piler/stat/:/var/piler/stat:ro,z
    restart: always
```
