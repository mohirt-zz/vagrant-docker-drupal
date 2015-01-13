#!/bin/bash
set -e

# Initiate DB if not intalled.
if [ ! -d "/var/lib/mysql/mysql" ]; then
  mysql_install_db --user=mysql --ldata=/var/lib/mysql/
  chown -R mysql:mysql /var/lib/mysql

  # Reference:
  # https://github.com/docker-library/mysql/blob/master/5.5/docker-entrypoint.sh
  tempSqlFile='/tmp/mysql-first-time.sql'
  cat > "$tempSqlFile" <<-EOSQL
  CREATE USER 'root'@'%' IDENTIFIED BY '' ;
  GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION ;
  DROP DATABASE IF EXISTS test ;
EOSQL
  echo 'FLUSH PRIVILEGES ;' >> "$tempSqlFile"

  echo 'Initiating MySQL server...'
  echo 'If you want to use other commands, e.g. bash, please create a helper container using the same image agian.'
  exec mysqld_safe --init-file="$tempSqlFile"
fi

exec "$@"
