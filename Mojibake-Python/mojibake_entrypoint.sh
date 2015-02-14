#!/bin/bash

start_mojibake_as_user()
{
    pybabel compile -d /opt/mojibake/apps/mojibake/translations
    python3.4 /opt/mojibake/apps/mojibake/tornado_srv.py *> /opt/mojibake/logs/mojibake.log &
}

export -f start_mojibake_as_user

su mojibake -c start_mojibake_as_user

