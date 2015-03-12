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

# Ensure we're up to date
echo "Pulling down latest version..."
cd /opt/mojibake/apps/mojibake && git init && git pull

if [ ! -f /mojibake/.mojibake_settings ]; then
    echo "Settings file does not yet exist, creating settings file..."

    cp /opt/mojibake/apps/mojibake/sample_credentials /mojibake/.mojibake_settings
    chown mojibake:mojibake /mojibake/.mojibake_settings
    chmod 600 /mojibake/.mojibake_settings

    echo "Set secret key and user details..."

    # Generate a secret key
    KEY=$(python3.4 -c "import base64,uuid;print(base64.b64encode(uuid.uuid4().bytes+uuid.uuid4().bytes).decode('utf-8'));")

    # Put the secret key we generated in config.py, use @ as a delimited since
    # the above can generate a key with a slash in it
    #sed -i "s@SECRET_KEY = '.*'@SECRET_KEY = \'$KEY\'@" /opt/mojibake/apps/mojibake/mojibake/settings.py
    sed -i "s@SECRET_KEY=.*@SECRET_KEY=$KEY@" /mojibake/.mojibake_settings

    # Add in the DB credentials to config.py
    #sed -i "s/USERNAME = '.*'/USERNAME = \'$DB_USER\'/" /opt/mojibake/apps/mojibake/mojibake/settings.py
    #sed -i "s/PASSWORD = '.*'/PASSWORD = \'$DB_PASS\'/" /opt/mojibake/apps/mojibake/mojibake/settings.py
    sed -i "s/USERNAME=.*/USERNAME=$DB_USER/" /mojibake/.mojibake_settings
    sed -i "s/PASSWORD=.*/PASSWORD=$DB_PASS/" /mojibake/.mojibake_settings

    echo "Running mojibake setup..."
    python3.4 /opt/mojibake/apps/mojibake/setup.py "$ADMIN_USER" "$ADMIN_PASS"
    chown -R mojibake:mojibake /opt/mojibake
fi

# Run the unit tests to ensure we don't have a dud build
echo "Running tests..."
python3.4 /opt/mojibake/apps/mojibake/tests.py

start_mojibake_as_user()
{
    echo "Compiling translations..."
    pybabel compile -d /opt/mojibake/apps/mojibake/mojibake/translations
    echo "Starting mojibake..."
    python3.4 /opt/mojibake/apps/mojibake/tornado_srv.py
}

export -f start_mojibake_as_user

su mojibake -c start_mojibake_as_user

