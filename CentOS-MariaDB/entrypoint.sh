#!/bin/bash
source /settings.sh

if [ -z "$DB_NAME" ]; then
    echo >&2 'error: The database name, DB_NAME, is not set'
    echo >&2 '  Did you forget to add -e DB_NAME=<name>'
    exit 1
fi

mysql -u root -e "CREATE DATABASE $DB_NAME"
mysql -u root $DB_NAME < /tmp/dump.sql



# original script below from https://github.com/docker-library/mariadb/
# with my explanations of what the more ambigious lines do
set -e

if [ "${1:0:1}" = '-' ]; then  # gets the first character of the arguments, and if it's '-'
    set -- mysqld "$@"
    # set -- clears existing arguments then sets the command to
    # mysqld <existing arguments>, basically prepending the arguments with mysqld
fi

if [ "$1" = 'mysqld' ]; then
    # read DATADIR from the MySQL config
    # basically mysqld --verbose --help lists the current settings in the config
    # the below prints out the value contained in "datadir   /var/lib/mysql/"
    # since datadir is the first value in the row, it only prints out the row that matches the pattern 'datadir'
    # the print $2 prints only the second part, the directory /var/lib/mysql
    DATADIR="$("$@" --verbose --help 2>/dev/null | awk '$1 == "datadir" { print $2; exit }')"

    # If the directory doesn't exist
    if [ ! -d "$DATADIR/mysql" ]; then
        if [ -z "$MYSQL_ROOT_PASSWORD" -a -z "$MYSQL_ALLOW_EMPTY_PASSWORD" ]; then
            echo >&2 'error: database is uninitialized and MYSQL_ROOT_PASSWORD not set'
            echo >&2 '  Did you forget to add -e MYSQL_ROOT_PASSWORD=... ?'
            exit 1
        fi

        echo 'Running mysql_install_db ...'
        mysql_install_db --datadir="$DATADIR"
        echo 'Finished mysql_install_db'

        # These statements _must_ be on individual lines, and _must_ end with
        # semicolons (no line breaks or comments are permitted).
        # TODO proper SQL escaping on ALL the things D:

        tempSqlFile='/tmp/mysql-first-time.sql'
        cat > "$tempSqlFile" <<-EOSQL
            DELETE FROM mysql.user ;
            CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' ;
            GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION ;
            DROP DATABASE IF EXISTS test ;
        EOSQL

        if [ "$MYSQL_DATABASE" ]; then
            echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` ;" >> "$tempSqlFile"
        fi

        if [ "$MYSQL_USER" -a "$MYSQL_PASSWORD" ]; then
            echo "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' ;" >> "$tempSqlFile"

            if [ "$MYSQL_DATABASE" ]; then
                echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%' ;" >> "$tempSqlFile"
            fi
        fi

        echo 'FLUSH PRIVILEGES ;' >> "$tempSqlFile"

        set -- "$@" --init-file="$tempSqlFile"
    fi

    chown -R mysql:mysql "$DATADIR"
fi

exec "$@"
