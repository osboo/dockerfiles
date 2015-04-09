## sensu-monitor ##

The monitor part of [sensu](http://sensuapp.org/) in a Docker container including it's dependencies Redis and RabbitMQ.

Best to generate the SSL certificates and keys outside of the container and pass them in as the clients will need the certs as well. To see how to generate them, consult the [docs](http://sensuapp.org/docs/latest/certificates).
