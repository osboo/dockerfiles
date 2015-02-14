# CentOS latest and Python 3.4.2
FROM centos:latest
MAINTAINER Jordan M <jordan@defestri.org>

RUN yum update -y
# Download required tools to compile
# Produces the below error but still works...
# There is no installed groups file.
# Maybe run: yum groups mark convert (see man yum)
RUN yum group install -y "Development tools"

# Install specific libs requires for Python to build
RUN yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel

# Download Python and compile
RUN cd /opt \
    && curl -O https://www.python.org/ftp/python/3.4.2/Python-3.4.2.tar.xz \
    && tar xf Python-3.4.2.tar.xz && cd Python-3.4.2 \
    &&./configure --prefix=/usr/local --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib" \
    && make \
    && make altinstall && cd /opt \
    && rm -f Python-3.4.2.tar.xz \
    && rm -rf Python-3.4.2/

# Remove all the build tools after building?
# yum remove_leaf_only or clean_requirements_on_remove?
#RUN yum install -y yum-utils
# leaves are only the following
#kmod-libs-14-9.el7.x86_64
#libcroco-0.6.8-5.el7.x86_64
#libgomp-4.8.2-16.2.el7_0.x86_64
#libunistring-0.9.3-9.el7.x86_64
# hardly worth uninstalling
