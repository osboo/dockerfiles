# CentOS latest and Python 3.4.8
FROM centos:latest

RUN yum update -y && yum clean all
# Download required tools to compile
# Produces the below error but still works...
# There is no installed groups file.
# Maybe run: yum groups mark convert (see man yum)
RUN yum group install -y "Development tools"

# Install specific libs requires for Python to build
RUN yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel

ENV PYTHON_VERSION="3.4.8"

# Download Python and compile
RUN cd /opt \
    && curl -O https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz \
    && tar xf Python-$PYTHON_VERSION.tar.xz && cd Python-$PYTHON_VERSION \
    &&./configure --prefix=/usr/local --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib" \
    && make \
    && make altinstall && cd /opt \
    && rm -f Python-$PYTHON_VERSION.tar.xz \
    && rm -rf Python-$PYTHON_VERSION/

# make some useful symlinks that are expected to exist
RUN cd /usr/local/bin \
    && ln -s easy_install-3.4 easy_install3 \
    && ln -s idle3.4 idle3 \
    && ln -s pydoc3.4 pydoc3 \
    && ln -s python3.4 python3 \
    && ln -s pip3.4 pip3 \
&& ln -s python-config3.4 python-config3

# Update curl to make it work with git
RUN yum -y install yum-plugin-ovl && \
    yum -y update nss curl libcurl


