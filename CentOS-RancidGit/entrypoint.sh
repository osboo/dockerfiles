#!/bin/bash
set -e

CONFIG_MD5=`md5sum /home/rancid/etc/rancid.conf | awk '{print $1}'`

# Check the md5 of the untouched config, if we've got an untouched config
# get to work.
if [ "$CONFIG_MD5" == "a8ae9476d12e4edc2bd09dbafda27986" ]; then

        if [ -z "$LIST_GROUPS" ]; then
                echo >&2 'error: no group details have been set'
                echo >&2 '  Did you forget to add -e LIST_GROUPS=...?'
                exit 1
        fi

        # Split the string into an array on ','
        IFS="," read -ra GROUP_LIST <<< "$LIST_GROUPS"

        # Now print it again with spaces as the separator instead of commas
        printf -v GROUP_SPACE "%s " "${GROUP_LIST[@]}"

        # Remove trailing space - see https://stackoverflow.com/a/3232433
        LIST_GROUP="$(echo -e "${GROUP_SPACE}" | sed -e 's/[[:space:]]*$//')"

        # Add our list of groups to rancid's config
        echo -e "\nLIST_OF_GROUPS=\"$LIST_GROUP\";" > /home/rancid/etc/rancid.conf
fi
