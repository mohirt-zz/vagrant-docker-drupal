# Pull base image.
FROM ubuntu:14.04

# Install exim4.
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
    exim4-daemon-light && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# exim4 default configs for container env.
RUN rm /etc/exim4/update-exim4.conf.conf
COPY etc/exim4/update-exim4.conf.conf /etc/exim4/
RUN echo 'log_file_path = syslog' >> /etc/exim4/conf.d/main/02_exim4-config_options
COPY etc/exim4/conf.d/router /etc/exim4/conf.d/router/
RUN update-exim4.conf

# So that we can mount this directory for debugging.
VOLUME ["/var/mail"]

# Start exim4.
CMD ["exim4", "-bdf", "-q30m"]

EXPOSE 25
