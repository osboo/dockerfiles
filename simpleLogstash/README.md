## simpleLogstash ##

Logstash container which catches the logs from Docker containers (using [logspout](https://github.com/gliderlabs/logspout)) as well as acting as a syslog server for the local server and ships the collected logs off... somewhere. Ideally to a central logstash server behind a redis instance (which queues events from remote shippers before sending them to logstash).

If you provide the `$REDIS_HOST` and `$REDIS_PORT` environment variables, this will be where the logs will be sent to, otherwise they'll be sent to stdout (useful for testing).

TO DO
-------------------------
- Add option to expose port so the server running this can forward its own logs to this container. Don't forget to forward TCP AND UDP when doing this (/udp to the -p option)
