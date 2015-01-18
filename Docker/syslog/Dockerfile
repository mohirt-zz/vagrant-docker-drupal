# Pull base image.
FROM ubuntu:14.04

# Copy rsyslog config for Drupal and Nginx.
COPY etc/rsyslog.d /etc/rsyslog.d/

# This is a volume data container, holding log entries by rsyslogd.
VOLUME ["/var/log"]

# Start syslogd only.
CMD ["rsyslogd", "-n"]
