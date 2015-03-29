## Dockerfiles ##

Dockerfiles I've made, work in progress at the moment

* ### [CentOS-Python3.4.2](https://registry.hub.docker.com/u/ardinor/centos-python3.4.2/) ###

  * Uses the latest version of CentOS and builds Python3.4.2

* ### [Mojibake-Python](https://registry.hub.docker.com/u/ardinor/mojibake-python/) ###

  * Dockerfile based off [ardinor/centos-python3.4.2](https://registry.hub.docker.com/u/ardinor/centos-python3.4.2/) that makes creates a container for the blogging engine [MØjibДĸe](https://github.com/ardinor/mojibake). This is a Python 3 application.

* ### [CentOS-MariaDB](https://registry.hub.docker.com/u/ardinor/centos-mariadb/) ###

 * Docker file using the latest CentOS to install MariaDB from mariadb.org's yum repo. It follows much of the path as the official [MariaDB repo](https://registry.hub.docker.com/_/mariadb/) except it's on CentOS and it offers support for creating multiple databases on intial creation. For more information, see the [README](https://github.com/ardinor/dockerfiles/tree/master/CentOS-MariaDB)

* ### [simpleLogstash](https://registry.hub.docker.com/u/ardinor/simplelogstash/) ###

 * Docker file for creating a simple instance of logstash with the option of shipping collected logs off to a redis instance, or just outputting them to stdout (fort testing). For more information, see the [README](https://github.com/ardinor/dockerfiles/tree/master/simpleLogstash)

Docker repository is located [here](https://hub.docker.com/u/ardinor/).

[Docker Compose](http://docs.docker.com/compose/) files are located in the [Compose files](Compose%20files/
) folder

TO DO
-------------------------
- Investigate [Consul](https://www.consul.io/intro/index.html)
