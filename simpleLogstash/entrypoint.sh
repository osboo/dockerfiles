#!/bin/bash

if [ ! -f /etc/logstash/conf.d/default.conf ]; then

    if [ -z "$REDIS_HOST" -o -z "$REDIS_PORT" ]; then
        echo 'REDIS_HOST and/or REDIS_PORT are not set'
        echo '  The Redis host details where the logs will be shipped to need to be added'
        echo '  Did you forget to add -e REDIS_HOST=<host> REDIS_PORT=<port>'
        echo '  Without these details logs received will just be sent to stdout'
    fi

    cat <<EOF >> /etc/logstash/conf.d/default.conf
input {
    tcp {
        port => "5544"
        type => "docker"
    }
    udp {
        port => "5544"
        type => "docker"
    }
    tcp {
        port => "5545"
        type => "syslog"
    }
    udp {
        port => "5545"
        type => "syslog"
    }
}

filter {
    if [type] == "docker" {
        grok {
          match => { "message" => "%{SYSLOGTIMESTAMP:syslog_timestamp} %{SYSLOGHOST:syslog_hostname} %{DATA:syslog_program}(?:\[%{POSINT:syslog_pid}\])?: %{GREEDYDATA:syslog_message}" }
          add_field => [ "received_at", "%{@timestamp}" ]
          add_field => [ "received_from", "%{host}" ]
        }
        syslog_pri { }
        date {
          match => [ "time", "ISO8601" ]
        }
    }
    if [type] == "syslog" {
        grok {
          match => { "message" => "%{SYSLOGTIMESTAMP:syslog_timestamp} %{SYSLOGHOST:syslog_hostname} %{DATA:syslog_program}(?:\[%{POSINT:syslog_pid}\])?: %{GREEDYDATA:syslog_message}" }
          add_field => [ "received_at", "%{@timestamp}" ]
          add_field => [ "received_from", "%{host}" ]
        }
        syslog_pri { }
        date {
          match => [ "syslog_timestamp", "MMM  d HH:mm:ss", "MMM dd HH:mm:ss" ]
        }
    }
}

EOF
    if [ "$REDIS_HOST" ]; then
        cat <<EOF >> /etc/logstash/conf.d/default.conf
output {
    stdout { codec => rubydebug }
    redis {
        host => "$REDIS_HOST"
        port => $REDIS_PORT
        data_type => "list"
        key => "logstash-%{type}"
    }
}
EOF
    else
        cat <<EOF >> /etc/logstash/conf.d/default.conf
output {
    stdout { codec => rubydebug }
}
EOF
    fi

fi

echo "Testing config..."
/opt/logstash-1.4.2/bin/logstash --config /etc/logstash/conf.d --configtest

echo "Starting..."
/opt/logstash-1.4.2/bin/logstash --config /etc/logstash/conf.d
