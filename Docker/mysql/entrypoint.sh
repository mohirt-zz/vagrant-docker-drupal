#! /bin/bash
set -e

# Blank out debian-sys-maint password.
sed 's/password = .*/password = /g' -i /etc/mysql/debian.cnf

# Initiate DB if not intalled.
if [ ! -d "/var/lib/mysql/mysql" ]; then
  # Only mysql is allowed to visit her own directory.
  chown -R mysql:mysql /var/lib/mysql
  chmod -R o= /var/lib/mysql

  # Generate random root password.
  root_password=$(date +%s | sha256sum | base64 | head -c 32)
  # Store the password at the persistent storage so that sysadmin can retrieve.
  echo $root_password > /var/lib/mysql/secret.txt
  chown root:root /var/lib/mysql/secret.txt
  chmod u=r,go= /var/lib/mysql/secret.txt

  mysql_install_db --user=mysql --ldata=/var/lib/mysql/

  # Reference:
  # https://github.com/docker-library/mysql/blob/master/5.5/docker-entrypoint.sh
  tempSqlFile='/tmp/mysql-first-time.sql'
  cat > "$tempSqlFile" <<-EOSQL
  DELETE FROM mysql.user ;
  CREATE USER 'root'@'%' IDENTIFIED BY '${root_password}' ;
  GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION ;
  GRANT ALL PRIVILEGES on *.* TO 'debian-sys-maint'@'localhost' IDENTIFIED BY '' WITH GRANT OPTION ;
  DROP DATABASE IF EXISTS test ;
  CREATE DATABASE IF NOT EXISTS \`PROJECT_CODE\` ;
  CREATE USER 'PROJECT_CODE'@'%' IDENTIFIED BY '' ;
  GRANT ALL ON \`PROJECT_CODE\`.* TO 'PROJECT_CODE'@'%' ;
EOSQL
  echo 'FLUSH PRIVILEGES ;' >> "$tempSqlFile"

  echo 'Initiating MySQL server...'
  echo 'If you want to use other commands, e.g. bash, please create a helper container using the same image agian.'
  exec mysqld_safe --init-file="$tempSqlFile"
fi

exec "$@"
