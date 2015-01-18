# Pull base image.
FROM ubuntu:14.04

# Remove all unrelated cron jobs.
RUN rm $(ls /etc/cron.*/* | grep -v logrotate)

# Copy Drupal and Nginx logrotate config.
COPY etc/logrotate.d /etc/logrotate.d/

# Start cron daemon.
CMD ["cron", "-f"]
