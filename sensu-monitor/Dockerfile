FROM centos:7
MAINTAINER Jordan M <jordan@defestri.org>

RUN yum install -y epel-release
# Install requirements
RUN yum install -y redis erlang rabbitmq-server supervisor

RUN mkdir -p /etc/rabbitmq/ssl
COPY ./certs/sensu_ca/cacert.pem /etc/rabbitmq/ssl
COPY ./certs/server/cert.pem /etc/rabbitmq/ssl
COPY ./certs/server/key.pem /etc/rabbitmq/ssl

COPY sensu.repo /etc/yum.repos.d/
RUN yum install -y sensu

RUN mkdir -p /etc/sensu/ssl

COPY supervisord.conf /etc/supervisord.conf

VOLUME /etc/sensu
VOLUME /var/log/sensu
