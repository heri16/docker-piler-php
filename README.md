# docker-piler-php
Piler web ui as Docker image (http://mailpiler.org)

## Configure New Installation:
```bash
docker run -ti --rm -v /usr/local/etc/piler/:/usr/local/etc/piler:ro -v /var/www/piler/:/var/www/piler:rw heri16/piler-php
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
      - /var/www/piler/:/var/www/piler:ro
      - /var/www/piler/tmp/:/var/www/piler/tmp:rw
      - /usr/local/etc/piler/:/usr/local/etc/piler:ro
      - /var/piler/store/:/var/piler/store:ro
      - /var/piler/stat/:/var/piler/stat:ro
    restart: always
```
