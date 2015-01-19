# CentOS latest and Python 3.4.2
FROM centos:latest
MAINTAINER Jordan M <jordan@defestri.org>
yum update -y
# Download required tools to compile
yum groupinstall -y "Development tools"
yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel
# Download Python and compile
cd ~
curl -O https://www.python.org/ftp/python/3.4.2/Python-3.4.2.tar.xz
tar xf Python-3.4.2.tar.xz
cd Python-3.4.2
./configure --prefix=/usr/local --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib"
make && make altinstall
cd ..
rm -f Python-3.4.2
rm -rf Python-3.4.2/