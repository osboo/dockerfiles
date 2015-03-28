### Logstash/Logspout Docker Compose file ###

Uses logspout to forward all container logs to a logstash instance which
then ships them off. The logstash container is linked to the logspout container and the the logspout container sends the syslog messages to logstash using the container's name as added in /etc/hosts

TO START:

cd to the directory and start the containers

    cd logstash-logspout/

    docker-compose up -d

