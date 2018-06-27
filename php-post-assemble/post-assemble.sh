#!/bin/bash

# Confusion due to symlinks in the path
sed -i "s%^\$root =.*$%\$root = '${APP_ROOT}/src/phabricator';%" phabricator/bin/*

# Custom preamble which forces HTTPS
cp preamble.php phabricator/support/preamble.php

# Disable opcache revalidation
sed -i 's/opcache.validate_timestamps=.*/opcache.validate_timestamps=0/' ${APP_ROOT}/etc/php.d/10-opcache.ini.template
