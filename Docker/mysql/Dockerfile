# Pull base image.
FROM ubuntu:14.04

# Install MySQL server.
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
    mysql-server && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# MySQL default configs, suitable for small Drupal site.
RUN rm /etc/mysql/my.cnf
COPY etc/mysql/my.cnf /etc/mysql/

# Add MySQL entrypoint script.
COPY entrypoint.sh /
RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["mysqld_safe"]

EXPOSE 3306
