#!/bin/bash

apachectl start

MYSQL_DB=db
MYSQL_USER=user
MYSQL_PASS=pass

# make mysql liston on all connections
sed -i "s/127\.0\.0\.1/0\.0\.0\.0/g" /etc/mysql/my.cnf
#sed -i "s/pma_/pma__/g" /etc/phpmyadmin/config.inc.php

/usr/bin/mysqld_safe > /dev/null 2>&1 &

# wait for mysql to start
for (( i=0 ; i<10 ; i++ )); do
  echo "Waiting for MySQL to start..."
  sleep 1
  mysql -uroot -p$(cat /.pass) -e "status" > /dev/null 2>&1 && break
done


gunzip /usr/share/doc/phpmyadmin/examples/create_tables.sql.gz
mysql -uroot -p$(cat /.pass) < /usr/share/doc/phpmyadmin/examples/create_tables.sql

# add phpmyadmin user
mysql -uroot -p$(cat /.pass) -e "CREATE USER 'pma'@'%' IDENTIFIED BY 'pmapass'"
mysql -uroot -p$(cat /.pass) -e "GRANT ALL PRIVILEGES ON phpmyadmin.* TO 'pma'@'%' WITH GRANT OPTION"


mysql -uroot -p$(cat /.pass) -e "CREATE DATABASE $MYSQL_DB"
mysql -uroot -p$(cat /.pass) -e "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '$MYSQL_PASS'"
mysql -uroot -p$(cat /.pass) -e "GRANT ALL PRIVILEGES ON $MYSQL_DB.* TO '${MYSQL_USER}'@'%' WITH GRANT OPTION"
mysql -uroot -p$(cat /.pass) -e "GRANT ALL PRIVILEGES ON phpmyadmin.* TO '${MYSQL_USER}'@'%' WITH GRANT OPTION"

tail -f /var/log/mysql/error.log