FROM java:7
MAINTAINER Jordan M <jordan@defestri.org>

RUN cd /tmp && \
    curl -O https://download.elasticsearch.org/logstash/logstash/logstash-1.4.2.tar.gz \
    && tar -zxvf logstash-1.4.2.tar.gz \
    && mv logstash-1.4.2 /opt \
    && rm logstash-1.4.2.tar.gz

RUN /opt/logstash-1.4.2/bin/plugin install contrib
RUN mkdir -p /etc/logstash/conf.d

ADD entrypoint.sh /

# Port we'll listen to for syslog messages (from logspout)
EXPOSE 5544

ENTRYPOINT ["/entrypoint.sh"]
