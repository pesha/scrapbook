#!/bin/sh

curl -sS http://packages.couchbase.com/ubuntu/couchbase.key | apt-key add -
curl -sS -o /etc/apt/sources.list.d/couchbase.list http://packages.couchbase.com/ubuntu/couchbase-ubuntu1404.list
apt-get update

# install PHP extensions
apt-get install -y libcouchbase2-libevent libcouchbase-dev libmemcached-dev zlib1g-dev libpq-dev
pecl install -f apcu pcs-1.3.3 igbinary couchbase memcached redis
docker-php-ext-enable apcu pcs igbinary couchbase memcached redis
docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
docker-php-ext-install pdo pdo_mysql pdo_pgsql
echo "apc.enable_cli=1" >> /usr/local/etc/php/php.ini
rm -rf /tmp/pear

# install composer and a bunch of dependencies
apt-get install -y git curl zip unzip
docker-php-ext-install zip pcntl
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# install dependencies
composer install

# install flysystem (not a hard dependency since it may not be needed, but we want to test it)
mkdir /tmp/cache
composer require league/flysystem