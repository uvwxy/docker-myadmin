#!/bin/bash

apachectl start

MYSQL_DB=db
MYSQL_USER=user
MYSQL_PASS=pass

/usr/bin/mysqld_safe > /dev/null 2>&1 &

# wait for mysql to start
for (( i=0 ; i<10 ; i++ )); do
  echo "Waiting for MySQL to start..."
  sleep 1
  mysql -uroot -p$(cat /.pass) -e "status" > /dev/null 2>&1 && break
done

# RUN rm -rf /var/lib/mysql/*
mysql -uroot -p$(cat /.pass) -e "CREATE DATABASE $MYSQL_DB"
mysql -uroot -p$(cat /.pass) -e "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '$MYSQL_PASS'"
mysql -uroot -p$(cat /.pass) -e "GRANT ALL PRIVILEGES ON $MYSQL_DB.* TO '${MYSQL_USER}'@'%' WITH GRANT OPTION"

tail -f /var/log/mysql/error.log 