### Mojibake Docker Compose ###

Docker Compose file for Mojibake that brings a database and mojibake up with separate data containers for each and a link between the two.

Can't seem to use underscore in service names...

TO START:

cd to the directory and start the containers
    cd mojibake/
    docker-compose up -d

TO DO:
-------------------------
- Send the logs somewhere, maybe a logstash container and then ship them off?
