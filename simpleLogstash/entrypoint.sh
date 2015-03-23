#!/bin/bash

if [ ! -f /etc/logstash/conf.d/default.conf ]; then

    if [ -z "$ES_HOST" -o -z "$ES_PORT" ]; then
        echo >&2 'error: ES_HOST and/or ES_PORT are not set'
        echo >&2 '  The Elastic Search host details need to be added'
        echo >&2 '  Did you forget to add -e ES_HOST=<host> ES_PORT=<port>'
        exit 1
    fi

fi

/opt/logstash-1.4.2/bin/logstash --config /etc/logstash/conf.d
