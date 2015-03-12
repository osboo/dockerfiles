#!/bin/bash
set -e

# function does_db_exist {
#     local result=$(mysql -u ${DB_USER} --password=${DB_PASS} -s -N -e "SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'mojibake'" information_schema)
#     if [ -z "${result}"]; then
#         # DB does not exist
#         return 1
#     else
#         # DB exists
#         return 2
#     fi
# }

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

# Generate a secret key
KEY=$(python3.4 -c "import base64,uuid;print(base64.b64encode(uuid.uuid4().bytes+uuid.uuid4().bytes).decode('utf-8'));")

# Put the secret key we generated in config.py, use @ as a delimited since
# the above can generate a key with a slash in it
sed -i "s@SECRET_KEY = '.*'@SECRET_KEY = \'$KEY\'@" /opt/mojibake/apps/mojibake/mojibake/settings.py

# Add in the DB credentials to config.py
sed -i "s/USERNAME = '.*'/USERNAME = \'$DB_USER\'/" /opt/mojibake/apps/mojibake/mojibake/settings.py
sed -i "s/PASSWORD = '.*'/PASSWORD = \'$DB_PASS\'/" /opt/mojibake/apps/mojibake/mojibake/settings.py

# does_db_exist
# if [ $? == 1 ]; then
#     # Run the setup, create the DBs and add the admin user
#     echo "Running mojibake setup..."
#     python3.4 /opt/mojibake/apps/mojibake/setup.py "$ADMIN_USER" "$ADMIN_PASS"
#     chown -R mojibake:mojibake /opt/mojibake
# fi

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

