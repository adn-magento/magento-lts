FROM debian:bullseye-slim

ARG UID=1000
ARG GID=1000
ARG APP_RECREATE="true"
ARG APP_TABLE="app_migration"
ARG APP_NAME="frontend"
ARG APP_UID="1"
ARG APP_TRIGGERS=""
ARG APP_VERSION="100.0.0"
ARG APP_MODE="run"
ARG APP_SECRET="a00001"
ARG APP_TIMEZONE="Europe/Paris"
ARG COMPOSER_AUTH=""

ENV \
APP_RECREATE="${APP_RECREATE}" \
APP_TABLE="${APP_TABLE}" \
APP_NAME="${APP_NAME}" \
APP_UID="${APP_UID}" \
APP_TRIGGERS="${APP_TRIGGERS}" \
APP_VERSION="${APP_VERSION}" \
APP_MODE="${APP_MODE}" \
APP_SECRET="${APP_SECRET}" \
APP_TIMEZONE="${APP_TIMEZONE}" \
COMPOSER_AUTH="${COMPOSER_AUTH}" \
COMPOSER_INSTALL="false" \
COMPOSER_DUMP="false" \
COMPOSER_ALLOW_SUPERUSER='0' \
COMPOSER_ALLOW_XDEBUG='0' \
COMPOSER_CACHE_DIR='/var/cache/composer' \
USE_SERVER="false" \
USE_CRONTAB="false" \
MAGE_INSTALL="false" \
MAGE_COMPILE="false" \
MAGE_CLEAN_CACHE="false" \
MAGE_DEBUG="0" \
MAGE_MODE="production" \
MAGE_RUN_CODE="base" \
MAGE_RUN_TYPE="website" \
CRONTAB_DEFAULT_SLEEP="60" \
CRONTAB_INDEX_SLEEP="60" \
MYSQL_HOST="mysql" \
MYSQL_PORT="3306" \
MYSQL_DATABASE="magento" \
MYSQL_USER="rootless" \
MYSQL_PASSWORD="nopassword" \
RABBITMQ_HOST="rabbitmq" \
RABBITMQ_PORT="5672" \
RABBITMQ_USER="rootless" \
RABBITMQ_PASSWORD="nopassword" \
FPM_PM="dynamic" \
FPM_PM__MAX_CHILDREN="5" \
FPM_PM__START_SERVERS="2" \
FPM_PM__MIN_SPARE_SERVERS="1" \
FPM_PM__MAX_SPARE_SERVERS="3" \
FPM_PM__PROCESS_IDLE_TIMEOUT="10s;" \
FPM_PM__MAX_REQUESTS="500" \
PHP_MEMORY_LIMIT="4G" \
PHP_REALPATH_CACHE_SIZE="4096K" \
PHP_REALPATH_CACHE_TTL="600" \
PHP_SENDMAIL_PATH="" \
PHP_XDEBUG__MODE="off" \
PHP_XDEBUG__CLIENT_PORT="9003" \
PHP_XDEBUG__CLIENT_HOST="172.17.0.1" \
PHP_XDEBUG__IDEKEY="PHPSTORM" \
PHP_OPCACHE__ENABLE="1" \
PHP_OPCACHE__ENABLE_CLI="1" \
PHP_OPCACHE__MEMORY_CONSUMPTION="256" \
PHP_OPCACHE__INTERNED_STRINGS_BUFFER="8" \
PHP_OPCACHE__MAX_ACCELERATED_FILES="60000" \
PHP_OPCACHE__MAX_WASTED_PERCENTAGE="5" \
PHP_OPCACHE__USE_CWD="1" \
PHP_OPCACHE__VALIDATE_TIMESTAMPS="0" \
PHP_OPCACHE__REVALIDATE_FREQ="2" \
PHP_OPCACHE__REVALIDATE_PATH="0" \
PHP_OPCACHE__SAVE_COMMENTS="1" \
PHP_OPCACHE__RECORDS_WARNING="0" \
PHP_OPCACHE__ENABLE_FILE_OVERRIDE="0" \
PHP_OPCACHE__OPTIMIZATION_LEVEL="0x7FFFBFFF" \
PHP_OPCACHE__DUPS_FIX="0" \
PHP_OPCACHE__BLACKLIST_FILENAME="/etc/php/8.1/opcache-*.blacklist" \
PHP_OPCACHE__MAX_FILE_SIZE="0" \
PHP_OPCACHE__CONSISTENCY_CHECKS="0" \
PHP_OPCACHE__FORCE_RESTART_TIMEOUT="180" \
PHP_OPCACHE__ERROR_LOG="/var/log/opcache" \
PHP_OPCACHE__LOG_VERBOSITY_LEVEL="1" \
PHP_OPCACHE__PREFERRED_MEMORY_MODEL="" \
PHP_OPCACHE__PROTECT_MEMORY="0" \
PHP_OPCACHE__RESTRICT_API="" \
PHP_OPCACHE__MMAP_BASE="" \
PHP_OPCACHE__CACHE_ID="" \
PHP_OPCACHE__FILE_CACHE="/var/cache/opcache" \
PHP_OPCACHE__FILE_CACHE_ONLY="0" \
PHP_OPCACHE__FILE_CACHE_CONSISTENCY_CHECKS="1" \
PHP_OPCACHE__FILE_CACHE_FALLBACK="1" \
PHP_OPCACHE__HUGE_CODE_PAGE="1" \
PHP_OPCACHE__VALIDATE_PERMISSION="0" \
PHP_OPCACHE__VALIDATE_ROOT="0" \
PHP_OPCACHE__OPT_DEBUG_LEVEL="0" \
PHP_OPCACHE__PRELOAD="/var/www/app/preload.php" \
PHP_OPCACHE__PRELOAD_USER="rootless" \
PHP_OPCACHE__LOCKFILE_PATH="/var/lock/opcache" \
PHP_OPCACHE__JIT="1255" \
PHP_OPCACHE__JIT_BUFFER_SIZE="250MB"

RUN set -eux; \
apt-get update \
&& apt-get install -y --no-install-recommends \
software-properties-common \
apt-transport-https \
lsb-release \
ca-certificates \
gnupg \
gnupg1 \
gnupg2 \
wget \
git \
patch \
curl \
unzip

RUN set -eux; \
adduser -h /home/rootless -g "rootless" -D -u ${UID} rootless; \
echo "rootless:${UID}:${GID}" >> /etc/subuid; \
echo "rootless:${UID}:${GID}" >> /etc/subgid; \
echo "rootless:rootless:${UID}:${GID}:/root:/bin" >> /etc/passwd; \
echo "rootless::${GID}:rootless" >> /etc/group

RUN set -eux; \
apt-get update \
&& wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add - \
&& echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list

RUN set -eux; \
apt-get update \
&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
supervisor \
default-mysql-client \
redis-tools \
nginx \
php8.1 \
php8.1-cli \
php8.1-fpm \
php8.1-common \
php8.1-bcmath \
php8.1-opcache \
php8.1-apcu \
php8.1-amqp \
php8.1-xdebug \
php8.1-redis \
php8.1-curl \
php8.1-soap \
php8.1-mbstring \
php8.1-mysql \
php8.1-xml \
php8.1-xsl \
php8.1-gd \
php8.1-intl \
php8.1-iconv \
php8.1-ftp \
php8.1-zip

RUN set -eux; \
rm -rf /etc/php/8.1/fpm/pool.d/*; \
rm -rf /etc/nginx/sites-available/*; \
rm -rf /etc/nginx/sites-enabled/*

COPY --chown=rootless:rootless server .

COPY --chown=rootless:rootless supervisor/ /etc/supervisor/conf.d/

RUN set -eux; \
ln -sf \
/etc/php/8.1/90-php.ini \
/etc/php/8.1/cli/conf.d/90-php.ini; \
ln -sf \
/etc/php/8.1/90-php.ini \
/etc/php/8.1/fpm/conf.d/90-php.ini; \
ln -sf \
/etc/nginx/sites-available/magento.conf \
/etc/nginx/sites-enabled/magento.conf

RUN set -eux; \
mkdir -p /tmp; \
chmod 777 -R /tmp; \
chown rootless:rootless /tmp; \
mkdir -p /etc/supervisor; \
chmod 777 -R /etc/supervisor; \
chown rootless:rootless /etc/supervisor; \
mkdir -p /etc/php; \
chmod 777 -R /etc/php; \
chown rootless:rootless /etc/php; \
mkdir -p /deploy; \
chmod 777 -R /deploy; \
chown rootless:rootless /deploy; \
mkdir -p /etc/nginx; \
chmod 777 -R /etc/nginx; \
chown rootless:rootless /etc/nginx; \
mkdir -p /var/pid; \
chmod 777 -R /var/pid/; \
chown rootless:rootless /var/pid; \
mkdir -p /var/run; \
chmod 777 -R /var/run/; \
chown rootless:rootless /var/run; \
mkdir -p /var/lock; \
mkdir -p /var/lock/opcache; \
chmod 777 -R /var/lock/; \
chown rootless:rootless /var/lock; \
mkdir -p /var/log; \
mkdir -p /var/log/supervisor; \
chmod 777 -R -R /var/log; \
chown rootless:rootless /var/log; \
mkdir -p /var/cache; \
mkdir -p /var/cache/composer; \
mkdir -p /var/cache/opcache; \
chmod 777 -R /var/cache; \
chown rootless:rootless /var/cache; \
mkdir -p /var/lib; \
mkdir -p /var/lib/nginx; \
mkdir -p /var/lib/nginx/body; \
chmod 777 -R /var/lib; \
chown rootless:rootless /var/lib; \
mkdir -p /var/www; \
chmod 777 -R /var/www; \
chown rootless:rootless /var/www; \
mkdir -p /bin; \
chmod 777 -R /bin; \
chown rootless:rootless /bin; \
touch /dev/stdout; \
chmod 777 -R /dev/stdout; \
chown rootless:rootless /dev/stdout; \
touch /etc/localtime; \
chmod 777 -R /etc/localtime; \
chown rootless:rootless /etc/localtime

RUN set -eux; \
rm -rf /etc/apt/sources.list.d/*; \
rm -rf /var/www/*;

COPY --chown=rootless:rootless . /var/www

RUN set -eux; \
rm -rf /var/www/docker; \
rm -rf /var/www/server; \
rm -rf /var/www/supervisor

COPY --chown=rootless:rootless docker/ /usr/bin

RUN set -eux; \
chmod +x -R /usr/bin; \
chmod +x -R /usr/sbin

WORKDIR /var/www

ENTRYPOINT ["docker-entrypoint"]

STOPSIGNAL SIGQUIT

EXPOSE 80

CMD ["supervisord"]

USER rootless
