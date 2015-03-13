# Mojibake's DB
FROM centos:latest
MAINTAINER Jordan M <jordan@defestri.org>

RUN yum update -y

ADD mariadb.repo /etc/yum.repos.d/mariadb.repo

RUM yum clean all && yum install -y MariaDB-server MariaDB-client

ADD settings.sh /
ADD config_mariadb.sh /

VOLUME ["/etc/mysql", "/var/lib/mysql"]

ENTRYPOINT ["/entrypoint.sh"]

CMD ["mysqld"]
