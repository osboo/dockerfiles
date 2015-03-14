## Mojibake-MariaDB ##

Set up mariadb with multiple databases if specified. To specify multiple databases list them as a comma delimited string in the environment variable MYSQL_DATABASE, e.g. `MYSQL_DATABASE=database-1,database-2`. At this stage any user you set up (with MYSQL_USER and MYSQL_PASSWORD) will have access to all the databases that are created.

**NB**. If you want to run mysql in the container for testing, you'll need to set the term environment variable first, `export TERM=dumb` then run `mysql` as discussed [here](https://github.com/dockerfile/mariadb/issues/3)
