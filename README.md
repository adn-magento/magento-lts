# Magento LTS

Version 2.4.3-p1

## Requirements

| Service           | Version |
| ----------------- | ------- |
| OS Unix           | *       |
| Docker            | 20      |
| Docker-Compose    | 1.28    |

## Image (rootless)

| Service | Version       |
|---------|---------------|
| OS      | bullseye-slim |
| Nginx   | 1.18          |
| PHP     | 7.4           |

## Install

Open hosts

```
sudo nano /etc/hosts
```

Copy rules

```
127.0.0.1       www.traefik.lan
127.0.0.1       www.phpmyadmin.lan
127.0.0.1       www.rabbitmq.lan
127.0.0.1       www.elasticsearch.lan
127.0.0.1       www.mailhog.lan
127.0.0.1       www.magento.lan
```


Update composer auth.json

```shell
cp auth.sample.json auth.json # Change the entries into auth.json
```

Install composer

https://getcomposer.org/download

```shell
wget -q https://getcomposer.org/download/latest-stable/composer.phar; \
mv composer.phar docker/bin-composer
```

Install Mailhog

https://github.com/mailhog/mhsendmail/releases/tag/v0.2.0

```shell
wget -q https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64; \
mv mhsendmail_linux_amd64 docker/bin-mhsendmail
```

Install Phing

https://www.phing.info

```shell
wget -q https://www.phing.info/get/phing-latest.phar; \
mv phing-latest.phar docker/bin-phing
```

Install Mkcert

https://github.com/FiloSottile/mkcert/releases/tag/v1.4.3

```shell
wget -q https://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-amd64; \
mv mkcert-v1.4.3-linux-amd64 docker/bin-mkcert
```

Build image

```shell
docker build . -t magento-lts:latest \
--build-arg UID="$(id -u)" \
--build-arg GID="$(id -g)"
```

Start containers

```shell
docker-compose up
```

Initialize magento

```shell
rm -rf generated/* \
&& rm -rf pub/static/* \
&& rm -rf var/view_preprocessed/* \
&& docker-compose exec magento bin/magento app:config:import \
&& docker-compose exec magento bin/magento setup:upgrade \
&& docker-compose exec magento bin/magento setup:di:compile \
&& docker-compose exec magento bin/magento indexer:reindex \
&& docker-compose exec magento bin/magento cache:clean \
&& docker-compose exec magento bin/magento cache:flush \
&& docker-compose exec magento bin/magento setup:static-content:deploy en_US -f
```

Create your admin user

```shell
docker-compose exec magento bin/magento admin:user:create \
--admin-firstname="$(whoami)" \
--admin-lastname="$(whoami)" \
--admin-email="$(whoami)@magento.lan" \
--admin-user="$(whoami)" \
--admin-password="$(whoami)123"
```

Or default admin user

```text
login : admin
password : admin123
```

Install Authenticator (Magento_TwoFactorAuth)

[Chrome](https://chrome.google.com/webstore/detail/authenticator/bhghoamapcdpbohphigoooaddinpkbai?hl=en)

[Firefox](https://addons.mozilla.org/fr/firefox/addon/auth-helper/)

## Patches

```shell
find patch/magento/* -name "*.patch" -print
```

https://support.magento.com/hc/en-us/articles/4426353041293-Security-updates-available-for-Adobe-Commerce-APSB22-12-

[APSB22-12](https://support.magento.com/hc/en-us/articles/4426353041293-Security-updates-available-for-Adobe-Commerce-APSB22-12-)

| Bulletin ID | Source                                      |
|-------------|---------------------------------------------|
| [APSB22-12](https://support.magento.com/hc/en-us/articles/4426353041293-Security-updates-available-for-Adobe-Commerce-APSB22-12-)   | patch/magento/framework/MDVA-43443.patch    |
| [APSB22-12](https://support.magento.com/hc/en-us/articles/4426353041293-Security-updates-available-for-Adobe-Commerce-APSB22-12-)   | patch/magento/framework/MDVA-43395.patch    |
| [APSB22-12](https://support.magento.com/hc/en-us/articles/4426353041293-Security-updates-available-for-Adobe-Commerce-APSB22-12-)   | patch/magento/module-email/MDVA-43443.patch |
| [APSB22-12](https://support.magento.com/hc/en-us/articles/4426353041293-Security-updates-available-for-Adobe-Commerce-APSB22-12-)   | patch/magento/module-email/MDVA-43395.patch |

## Configuration

### Environment

Configure your environment via [.env](/.env) files for local

Magento best practices 

@see https://devdocs.magento.com/guides/v2.4/config-guide/prod/config-reference-var-name.html

### PHP

To configure php, use the environment variable.

Eg. set memory_limit = -1

PHP_MEMORY_LIMIT = -1

Eg. set opcache.enable = 1

PHP_OPCACHE__ENABLE = 1

the "PHP_" prefix is removed and the double underscores are replaced by dots

The entire configuration overlay is in the docker container

```shell
cat /etc/php/7.4/90-php.ini
```

@see [docker/docker-entrypoint](/docker/docker-entrypoint) line 7

example : 

```shell
docker-compose exec magento env | grep "PHP_"
PHP_SENDMAIL_PATH=/usr/bin/bin-mhsendmail --smtp-addr=mailhog:1025
PHP_XDEBUG__MODE=debug,coverage
PHP_XDEBUG__CLIENT_PORT=9003
PHP_XDEBUG__IDEKEY=PHPSTORM
PHP_OPCACHE__ENABLE=1
PHP_OPCACHE__CLI_ENABLE=1
PHP_OPCACHE__REVALIDATE_FREQ=0
PHP_OPCACHE__VALIDATE_TIMESTAMPS=1
PHP_MEMORY_LIMIT=4G
PHP_REALPATH_CACHE_SIZE=4096K
PHP_REALPATH_CACHE_TTL=600
PHP_XDEBUG__CLIENT_HOST=172.17.0.1
PHP_OPCACHE__ENABLE_CLI=1
PHP_OPCACHE__MEMORY_CONSUMPTION=256
PHP_OPCACHE__INTERNED_STRINGS_BUFFER=8
PHP_OPCACHE__MAX_ACCELERATED_FILES=60000
PHP_OPCACHE__MAX_WASTED_PERCENTAGE=5
PHP_OPCACHE__USE_CWD=1
PHP_OPCACHE__REVALIDATE_PATH=0
PHP_OPCACHE__SAVE_COMMENTS=1
PHP_OPCACHE__RECORDS_WARNING=0
PHP_OPCACHE__ENABLE_FILE_OVERRIDE=0
PHP_OPCACHE__OPTIMIZATION_LEVEL=0x7FFFBFFF
PHP_OPCACHE__DUPS_FIX=0
PHP_OPCACHE__BLACKLIST_FILENAME=/etc/php/7.4/opcache-*.blacklist
PHP_OPCACHE__MAX_FILE_SIZE=0
PHP_OPCACHE__CONSISTENCY_CHECKS=0
PHP_OPCACHE__FORCE_RESTART_TIMEOUT=180
PHP_OPCACHE__ERROR_LOG=/var/log/opcache
PHP_OPCACHE__LOG_VERBOSITY_LEVEL=1
PHP_OPCACHE__PREFERRED_MEMORY_MODEL=
PHP_OPCACHE__PROTECT_MEMORY=0
PHP_OPCACHE__RESTRICT_API=
PHP_OPCACHE__MMAP_BASE=
PHP_OPCACHE__CACHE_ID=
PHP_OPCACHE__FILE_CACHE=/var/cache/opcache
PHP_OPCACHE__FILE_CACHE_ONLY=0
PHP_OPCACHE__FILE_CACHE_CONSISTENCY_CHECKS=1
PHP_OPCACHE__FILE_CACHE_FALLBACK=1
PHP_OPCACHE__HUGE_CODE_PAGE=1
PHP_OPCACHE__VALIDATE_PERMISSION=0
PHP_OPCACHE__VALIDATE_ROOT=0
PHP_OPCACHE__OPT_DEBUG_LEVEL=0
PHP_OPCACHE__PRELOAD=/var/www/html/app/preload.php
PHP_OPCACHE__PRELOAD_USER=rootless
PHP_OPCACHE__LOCKFILE_PATH=/var/lock/opcache
```

An opcache preload is implemented to accelerate the reading of static data or data generated by magento.

@see [app/preload.php](/app/preload.php)

### Supervisor

```shell
supervisorctl help

# default commands (type help <topic>):
# =====================================
# add    exit      open  reload  restart   start   tail   
# avail  fg        pid   remove  shutdown  status  update 
# clear  maintail  quit  reread  signal    stop    version
```

```shell
supervisorctl 

# crontab:crontab-default_00       RUNNING   pid 92039, uptime 0:00:24
# crontab:crontab-index_00         RUNNING   pid 90682, uptime 0:09:59
# server:server-fpm_00             RUNNING   pid 1952, uptime 10:32:06
# server:server-nginx_00           RUNNING   pid 1951, uptime 10:32:06

```

```shell
supervisorctl restart server:*

# server:server-nginx_00: stopped
# server:server-fpm_00: stopped
# server:server-nginx_00: started
# server:server-fpm_00: started
```

```shell
supervisorctl stop crontab:*

# crontab:crontab-index_00: stopped
# crontab:crontab-default_00: stopped
```

@see [supervisor/crontab.conf](/supervisor/crontab.conf) [supervisor/server.conf](/supervisor/server.conf)

## Test 

Phpunit

```shell
docker-compose exec magento bin-composer exec phpunit
```

## Extra Packages

### Logger

https://github.com/adn-magento/logger

```shell
docker-compose exec magento bin-composer require adn-magento/logger
```

### Etl

https://github.com/adn-magento/etl

```shell
docker-compose exec magento bin-composer require adn-magento/etl
```
