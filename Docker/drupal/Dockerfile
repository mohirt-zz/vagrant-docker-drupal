# Pull base image.
FROM ubuntu:14.04

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y wget

# Install Nginx, PHP and drush.
RUN \
  wget -qO - http://nginx.org/keys/nginx_signing.key | apt-key add - && \
  echo 'deb http://nginx.org/packages/ubuntu/ trusty nginx' > /etc/apt/sources.list.d/nginx.list && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
    nginx \
    php5-fpm \
    php5-cli \
    php5-mysql \
    php5-mcrypt \
    php5-gd \
    php5-curl \
    php5-json \
    mysql-client \
    drush && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Prepare Nginx required directories.
RUN \
  mkdir -p /var/cache/nginx/microcache && \
  chown -R www-data:www-data /var/cache/nginx/microcache && \
  mkdir -p /var/log/nginx && \
  chown -R www-data:www-data /var/log/nginx && \
  mkdir -p /var/www && \
  chown www-data:www-data /var/www
# Remove default Nginx configs.
RUN rm -rf /etc/nginx/*
# Use Nginx configs originated from https://github.com/perusio
# for Drupal 7, and then modified for Ubuntu and Docker taste.
COPY etc/nginx /etc/nginx/

# PHP configs.
RUN \
  rm /etc/php5/cli/php.ini && \
  rm /etc/php5/fpm/php.ini && \
  rm /etc/php5/fpm/php-fpm.conf && \
  rm /etc/php5/fpm/pool.d/*
COPY etc/php5/cli /etc/php5/cli/
COPY etc/php5/fpm /etc/php5/fpm/

# Copy Drupal source code into image.
RUN rm -rf /var/www/drupal/*
COPY drupal /var/www/drupal/
RUN chown -R root:root /var/www/drupal && chmod -R o= /var/www/drupal

# Remove unnecesary cron jobs, we only want Drupal and php cronjobs.
RUN rm -f /etc/cron.*/*
COPY etc/cron.d /etc/cron.d/

COPY entrypoint.sh /
RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]

EXPOSE 80
EXPOSE 9001
