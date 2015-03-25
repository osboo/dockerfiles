### Mojibake Docker Compose ###

Docker Compose file for Mojibake that brings a database and mojibake up with separate data containers for each and a link between the two.

Can't seem to use underscore in service names...

Uses logspout to forward all container logs to a logstash instance which
then ships them off. The logstash container is linked to the logspout container and the the logspout container sends the syslog messages to logstash using the container's name as added in /etc/hosts

TO START:

cd to the directory and start the containers

    cd mojibake/

    docker-compose up -d

TO DO:
-------------------------
- Add support for logspout to send logs to a linked container
