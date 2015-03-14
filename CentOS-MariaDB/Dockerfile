# Mojibake's DB
FROM centos:latest
MAINTAINER Jordan M <jordan@defestri.org>

RUN groupadd -r mysql && useradd -r -g mysql mysql

RUN yum update -y

ADD mariadb.repo /etc/yum.repos.d/mariadb.repo

RUN rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB && yum clean all && yum install -y hostname MariaDB-server

RUN sed -i "/\[mysqld\]/a\\user=mysql" /etc/my.cnf.d/server.cnf
RUN sed -i "/\[mysqld\]/a\\bind-address=127.0.0.1" /etc/my.cnf.d/server.cnf

ADD entrypoint.sh /

VOLUME ["/etc/my.cnf.d", "/var/lib/mysql"]

ENTRYPOINT ["/entrypoint.sh"]

CMD ["mysqld"]
