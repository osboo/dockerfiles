#!/bin/bash

if [ -z "$DB_NAME" ]; then
    echo >&2 'error: The database name, DB_NAME, is not set'
    echo >&2 '  Did you forget to add -e DB_NAME=<name>'
    exit 1
fi

mysql -u root -e "CREATE DATABASE $DB_NAME"
mysql -u root $DB_NAME < /tmp/dump.sql
