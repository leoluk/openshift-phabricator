#!/bin/bash

# Confusion due to symlinks in the path
sed -i "s%^\$root =.*$%\$root = '${APP_ROOT}/src/phabricator';%" phabricator/bin/*

# SSH won't know about our fancy PATH override
sed -i '1 s%^.*$%#!/opt/rh/rh-php71/root/usr/bin/php%' phabricator/bin/ssh-exec

# Custom preamble which forces HTTPS
cp preamble.php phabricator/support/preamble.php

# Disable opcache revalidation
sed -i 's/opcache.validate_timestamps=.*/opcache.validate_timestamps=0/' ${APP_ROOT}/etc/php.d/10-opcache.ini.template

# Apply custom Phabricator patches
if [ "${PHAB_APPLY_PATCHES}" = "true" ]; then
  for path in patches/phabricator/*; do
    patch -d phabricator -p1 < "$path"
  done
fi
