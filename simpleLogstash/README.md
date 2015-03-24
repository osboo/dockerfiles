## simpleLogstash ##

Logstash container which catches the logs from Docker containers (using [logspout](https://github.com/gliderlabs/logspout)) and the local server before shipping them off. Ideally to a central logstash server behind a redis instance (which queues events from remote shippers before sending them to logstash).

TO DO
-------------------------
- Add option to expose port so the server running this can forward its own logs to this container. Don't forget to forward TCP AND UDP when doing this (/udp to the -p option)
