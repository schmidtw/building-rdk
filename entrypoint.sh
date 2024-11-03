#!/bin/bash
set -e

if [ "$USER_ID" != "0" ] && [ "$GROUP_ID" != "0" ]; then
    cp -a /.ssh /home/notRoot/.ssh

    # Some newer versions have this keyword, but the older ones don't
    sed -i '/RequiredRSASize/Id' /home/notRoot/.ssh/config

    usermod -u $USER_ID notRoot 2>/dev/null
    groupmod -g $GROUP_ID notRoot

    exec gosu notRoot "$@"
else
    exec "$@"
fi
