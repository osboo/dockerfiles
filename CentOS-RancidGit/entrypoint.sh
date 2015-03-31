#!/bin/bash
set -e

CONFIG_MD5=`md5sum /home/rancid/etc/rancid.conf | awk '{print $1}'`

# Check the md5 of the untouched config, if we've got an untouched config
# get to work.
if [ "$CONFIG_MD5" == "a8ae9476d12e4edc2bd09dbafda27986" ]; then

fi
