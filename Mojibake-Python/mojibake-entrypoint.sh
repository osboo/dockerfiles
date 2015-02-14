#!/bin/bash
set -e

if [ -z "$ADMIN_USER" -o -z "$ADMIN_PASS" ]; then
    echo >&2 'error: ADMIN_USER and/or ADMIN_PASS is not set'
    echo >&2 '  Did you forget to add -e ADMIN_USER=<name> ADMIN_PASS=<pass>'
    exit 1
fi

echo "Running mojibake setup..."
echo $ADMIN_USER
echo $ADMIN_PASS

python3.4 /opt/mojibake/apps/mojibake/setup.py "$ADMIN_USER" "$ADMIN_PASS"
chown -R mojibake:mojibake /opt/mojibake

start_mojibake_as_user()
{
    pybabel compile -d /opt/mojibake/apps/mojibake/translations
    python3.4 /opt/mojibake/apps/mojibake/tornado_srv.py *> /opt/mojibake/logs/mojibake.log &
}

export -f start_mojibake_as_user

su mojibake -c start_mojibake_as_user

