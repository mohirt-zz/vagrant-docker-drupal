# Pull base image.
FROM ubuntu:14.04

# TODO: remove following items.
COPY etc/rsyslog.conf /etc/

# This is a volume data container, holding log entries by rsyslogd.
VOLUME ["/var/log"]

# Start syslogd only.
CMD ["rsyslogd", "-n"]
