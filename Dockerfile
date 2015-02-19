FROM ubuntu:14.04
MAINTAINER Paul Smith code@uvwxy.de

# add faster mirror ;)
ADD sources.list /etc/apt/

RUN apt-get update
RUN apt-get -y install pwgen

RUN echo $(pwgen -s -1 16) > /.pass
ENV MYSQL_ROOT_PWD $(cat /.pass)

RUN echo "mysql-server-5.6 mysql-server/root_password password $(cat /.pass)" | debconf-set-selections
RUN echo "mysql-server-5.6 mysql-server/root_password_again password $(cat /.pass)" | debconf-set-selections
RUN echo "mysql-server-5.6 mysql-server/start_on_boot boolean false" | debconf-set-selections

RUN echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
RUN echo "phpmyadmin phpmyadmin/dbconfig-install boolean false" | debconf-set-selections
RUN echo "phpmyadmin phpmyadmin/mysql/admin-user string root" | debconf-set-selections
RUN echo "phpmyadmin phpmyadmin/mysql/admin-pass password $(cat /.pass)" | debconf-set-selections
RUN echo "phpmyadmin phpmyadmin/mysql/app-pass password admin" |debconf-set-selections
RUN echo "phpmyadmin phpmyadmin/app-password-confirm password admin" | debconf-set-selections
RUN echo "phpmyadmin phpmyadmin/install-error	select	ignore" | debconf-set-selections

RUN apt-get -y install mysql-server-5.6 phpmyadmin

# increase mem + file upload size
ADD php.ini /etc/php5/apache2/ 
# static config file
ADD config.inc.php /etc/phpmyadmin/

ADD start.sh /

CMD ["bash", "/start.sh"]