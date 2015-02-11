# Mojibake
FROM ardinor/centos-python3.4.2
MAINTAINER Jordan M <jordan@defestri.org>

# Need UTF-8 support, doesn't get set automatically
ENV LANGUAGE en_AU.UTF-8
ENV LANG en_AU.UTF-8
ENV LC_ALL en_AU.UTF-8

# Make directories
# Move logs into a data container app
RUN mkdir -p /opt/mojibake/logs && mkdir -p /opt/mojibake/apps
RUN cd /opt/mojibake/apps/ && git clone https://github.com/ardinor/mojibake.git
#RUN ln -s /opt/mojibake/apps/mojibake /opt/mojibake/apps/current
# Really no need to use virtualenv on docker?
#pyvenv-3.4 env
#source env/bin/activate

# Install requirements
# Remove oursql from requirments.txt, install will fail and prevent others downloading
RUN cd /opt/mojibake/apps/mojibake && pip install -r requirements.txt
# Oursql install will fail, Python3 version isn't on PyPy yet
RUN yum install -y mariadb-devel wget
RUN pip install cython
# Curl won't get it, need to use wget
RUN cd /tmp \
    && wget https://launchpad.net/oursql/py3k/py3k-0.9.4/+download/oursql-0.9.4.tar.gz \
    && tar xf oursql-0.9.4.tar.gz \
    && cd oursql-0.9.4 \
    && python3.4 setup.py build_ext \
    && python3.4 setup.py install

# Set up the DB here
cd /opt/mojibake/current
python3.4 setup.py $ADMIN_USERNAME $ADMIN_PASSWORD

# Finally compile translations
pybabel compile -d mojibake/translations

WORKDIR /opt/mojibake/apps/current
EXPOSE 8000
ENTRYPOINT python3.4 tornado_srv.py
