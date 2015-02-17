#!/bin/bash
set -e

if [ -z "$ADMIN_USER" -o -z "$ADMIN_PASS" ]; then
    echo >&2 'error: ADMIN_USER and/or ADMIN_PASS is not set'
    echo >&2 '  Did you forget to add -e ADMIN_USER=<name> ADMIN_PASS=<pass>'
    exit 1
fi

if [ -z "$DB_USER" -o -z "$DB_PASS" ]; then
    echo >&2 'error: DB_USER and/or DB_PASS is not set'
    echo >&2 '  Did you forget to add -e DB_USER=<name> DB_PASS=<pass>'
    exit 1
fi

# Generate a secret key
KEY=$(python3.4 -c "import base64,uuid;print(base64.b64encode(uuid.uuid4().bytes+uuid.uuid4().bytes));")

# Put the secret key we generated in config.py, use @ as a delimited since
# the above can generate a key with a slash in it
sed -i "s@SECRET_KEY = '.*'@SECRET_KEY = \'$KEY\'@" /opt/mojibake/apps/mojibake/mojibake/settings.py

# Add in the DB credentials to config.py
sed -i "s/USERNAME = '.*'/USERNAME = \'$DB_USER\'/" /opt/mojibake/apps/mojibake/mojibake/settings.py
sed -i "s/PASSWORD = '.*'/PASSWORD = \'$DB_PASS\'/" /opt/mojibake/apps/mojibake/mojibake/settings.py

echo "Running tests..."
python3.4 /opt/mojibake/apps/mojibake/tests.py

echo "Running mojibake setup..."
python3.4 /opt/mojibake/apps/mojibake/setup.py "$ADMIN_USER" "$ADMIN_PASS"
chown -R mojibake:mojibake /opt/mojibake

start_mojibake_as_user()
{
    pybabel compile -d /opt/mojibake/apps/mojibake/translations
    python3.4 /opt/mojibake/apps/mojibake/tornado_srv.py *> /opt/mojibake/logs/mojibake.log &
}

export -f start_mojibake_as_user

su mojibake -c start_mojibake_as_user

