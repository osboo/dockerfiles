### Mojibake Docker Compose ###

Docker Compose file for Mojibake that brings a database and mojibake up with separate data containers for each and a link between the two.

Can't seem to use underscore in service names...

Uses logspout to forward all container logs to a logstash instance which
then ships them off. The current arrangement is less than ideal. logstash listens on ports 5544 and 5545 allowing it to collect logspout (5544) logs and the host's syslogs (5545). In order to send the logs to logstash from logspout we use the address of the host's Docker ethernet bridge (which is 172.17.42.1). Ideally you'd just link the containers but logspout doesn't currently support sending logs to a linked container.

TO START:

cd to the directory and start the containers

    cd mojibake/

    docker-compose up -d

TO DO:
-------------------------
- Add support for logspout to send logs to a linked container
