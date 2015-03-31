FROM centos:7
MAINTAINER Jordan M <jordan@defestri.org>

RUN yum update -y && yum clean all
RUN yum group install -y "Development tools"
RUN yum install -y git cvs expect wget cronie

RUN useradd rancid

RUN cd /tmp &&
    wget https://github.com/dotwaffle/rancid-git/archive/2.3.8.tar.gz &&
    tar xvf 2.3.8.tar.gz &&
    cd rancid-git-2.3.8/ &&
    ./configure --prefix=/home/rancid --localstatedir=/home/rancid/var/rancid &&
    make install

RUN chown -R rancid:rancid /home/rancid

EXPOSE /home/rancid/etc

ADD entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
