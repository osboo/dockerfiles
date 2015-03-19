## CentOS-MariaDB ##

Docker file using the latest CentOS to install MariaDB from mariadb.org's yum repo. It follows much of the path as the official [MariaDB repo](https://registry.hub.docker.com/_/mariadb/) except it's on CentOS and it offers support for creating multiple databases on intial creation.

To specify multiple databases list them as a comma delimited string in the environment variable MYSQL_DATABASE, e.g. `MYSQL_DATABASE=database-1,database-2`. At this stage any user you set up (with MYSQL_USER and MYSQL_PASSWORD) will have access to all the databases that are created.

Otherwise uses the same environment variables as the official MariaDB dockerfile.
- MYSQL_ROOT_PASSWORD
- MYSQL_USER
- MYSQL_PASSWORD
- MYSQL_DATABASE


**NB**. If you want to run mysql in the container for testing, you'll need to set the term environment variable first, `export TERM=dumb` then run `mysql` as discussed [here](https://github.com/dockerfile/mariadb/issues/3)
