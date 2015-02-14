# Mojibake
FROM ardinor/centos-python3.4.2
MAINTAINER Jordan M <jordan@defestri.org>

# Need UTF-8 support, doesn't get set automatically
ENV LANGUAGE en_AU.UTF-8
ENV LANG en_AU.UTF-8
ENV LC_ALL en_AU.UTF-8

RUN yum install -y git

# Make directories
# Move logs into a data container app
RUN mkdir -p /opt/mojibake/logs && mkdir -p /opt/mojibake/apps
RUN cd /opt/mojibake/apps/ && git clone https://github.com/ardinor/mojibake.git

# Install requirements
# Remove oursql from requirments.txt, install will fail and prevent others downloading
RUN cd /opt/mojibake/apps/mojibake && pip3.4 install -r requirements.txt
# Oursql install will fail, Python3 version isn't on PyPy yet
RUN yum install -y mariadb-devel wget
RUN pip3.4 install cython
# Curl won't get it, need to use wget
RUN cd /tmp \
    && wget https://launchpad.net/oursql/py3k/py3k-0.9.4/+download/oursql-0.9.4.tar.gz \
    && tar xf oursql-0.9.4.tar.gz \
    && cd oursql-0.9.4 \
    && python3.4 setup.py build_ext \
    && python3.4 setup.py install

# Add the user the mojibake will be running under here
RUN useradd -r mojibake && chown -R mojibake:mojibake /opt/mojibake

COPY mojibake_entrypoint.sh /opt/
RUN chmod +x /opt/mojibake_entrypoint.sh && chown mojibake:mojibake /opt/mojibake_entrypoint.sh
# Can't run it yet, getting permission denied error on the entry point...

EXPOSE 8000
ENTRYPOINT ["/opt/mojibake_entrypoint.sh"]
