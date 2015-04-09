FROM centos:7
MAINTAINER Jordan M <jordan@defestri.org>

RUN yum install -y epel-release
# Install requirements
RUN yum install -y redis erlang rabbitmq-server supervisor

# Copy across the SSL certs and keys for RabbitMQ
RUN mkdir -p /etc/rabbitmq/ssl
COPY ./certs/sensu_ca/cacert.pem /etc/rabbitmq/ssl
COPY ./certs/server/cert.pem /etc/rabbitmq/ssl
COPY ./certs/server/key.pem /etc/rabbitmq/ssl

# Copy across the sensu repo and install sensu
COPY sensu.repo /etc/yum.repos.d/
RUN yum install -y sensu uchiwa

RUN mkdir -p /etc/sensu/ssl

COPY supervisord.conf /etc/supervisord.conf

VOLUME /etc/sensu
VOLUME /var/log/sensu
