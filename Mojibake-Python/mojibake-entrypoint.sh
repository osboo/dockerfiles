#!/bin/bash
set -e

function wait_until_db_ready
{
    DB_URL="$MOJIBAKEDB_PORT_3306_TCP_ADDR/$MOJIBAKEDB_PORT_3306_TCP_PORT"
    echo "Attempting connection to $DB_URL..."

    # http://stackoverflow.com/a/9609247
    # Use file descriptor 6 to check tcp connection
    while ! exec 6<>/dev/tcp/$MOJIBAKEDB_PORT_3306_TCP_ADDR/$MOJIBAKEDB_PORT_3306_TCP_PORT; do
        echo "$(date) - unable to connect to DB at $DB_URL address waiting..."
        sleep 1
    done

    # close output connection
    exec 6>&-
    # close input connection
    exec 6<&-

    echo "Connected to DB succesfully, continuing..."

    return 0
}

# Ensure we're up to date
echo "Pulling down latest version..."
cd /opt/mojibake/apps/mojibake && git init && git pull

if [ ! -f /var/lib/mojibake/.mojibake_settings ]; then

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

    if [ -z "$MOJIBAKEDB_PORT_3306_TCP" ]; then
        echo >&2 'error: missing MOJIBAKEDB_PORT_3306_TCP environment variable'
        echo >&2 ' Did you forget to start a DB container?'
        exit 1
    fi

    wait_until_db_ready

    echo "Settings file does not yet exist, creating settings file..."

    cp /opt/mojibake/apps/mojibake/sample_credentials /var/lib/mojibake/.mojibake_settings
    chown mojibake:mojibake /var/lib/mojibake/.mojibake_settings
    chmod 600 /var/lib/mojibake/.mojibake_settings

    echo "Set secret key and user details..."

    # Generate a secret key
    KEY=$(python3.4 -c "import base64,uuid;print(base64.b64encode(uuid.uuid4().bytes+uuid.uuid4().bytes).decode('utf-8'));")

    # Put the secret key we generated in config.py, use @ as a delimited since
    # the above can generate a key with a slash in it
    #sed -i "s@SECRET_KEY = '.*'@SECRET_KEY = \'$KEY\'@" /opt/mojibake/apps/mojibake/mojibake/settings.py
    sed -i "s@SECRET_KEY=.*@SECRET_KEY=$KEY@" /var/lib/mojibake/.mojibake_settings

    # Add in the DB credentials to config.py
    #sed -i "s/USERNAME = '.*'/USERNAME = \'$DB_USER\'/" /opt/mojibake/apps/mojibake/mojibake/settings.py
    #sed -i "s/PASSWORD = '.*'/PASSWORD = \'$DB_PASS\'/" /opt/mojibake/apps/mojibake/mojibake/settings.py
    sed -i "s/USERNAME=.*/USERNAME=$DB_USER/" /var/lib/mojibake/.mojibake_settings
    sed -i "s/PASSWORD=.*/PASSWORD=$DB_PASS/" /var/lib/mojibake/.mojibake_settings

    echo "Running mojibake setup..."
    python3.4 /opt/mojibake/apps/mojibake/setup.py "$ADMIN_USER" "$ADMIN_PASS"
    chown -R mojibake:mojibake /opt/mojibake
fi

# Run the unit tests to ensure we don't have a dud build
echo "Running tests..."
python3.4 /opt/mojibake/apps/mojibake/tests.py

start_mojibake_as_user()
{
    # Compile the translations as the user so we have the right permissions
    # and we don't have to chown/chmod it later
    echo "Compiling translations..."
    pybabel compile -d /opt/mojibake/apps/mojibake/mojibake/translations
    echo "Starting mojibake..."
    python3.4 /opt/mojibake/apps/mojibake/tornado_srv.py
}

# We need to use set it as an environment variable (export) in order
# for it to run properly with su
export -f start_mojibake_as_user

su mojibake -c start_mojibake_as_user

