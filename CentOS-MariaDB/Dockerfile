# Mojibake's DB
FROM centos:latest
MAINTAINER Jordan M <jordan@defestri.org>

RUN yum update -y

ADD mariadb.repo /etc/yum.repos.d/mariadb.repo

RUN rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB && yum clean all && yum install -y MariaDB-server

RUN sed -ri 's/^(bind-address|skip-networking)/;\1/' /etc/mysql/my.cnf

ADD settings.sh /
ADD entrypoint.sh /

VOLUME ["/etc/mysql", "/var/lib/mysql"]

ENTRYPOINT ["/entrypoint.sh"]

CMD ["mysqld"]
