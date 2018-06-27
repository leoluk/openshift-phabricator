#!/bin/bash

# Confusion due to symlinks in the path
sed -i "s%^\$root =.*$%\$root = '${APP_ROOT}/src/phabricator';%" phabricator/bin/*

# Custom preamble which forces HTTPS
cp preamble.php phabricator/support/preamble.php

