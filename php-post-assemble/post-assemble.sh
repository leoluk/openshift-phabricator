#!/bin/bash

# Confusion due to symlinks in the path
sed -i 's/dirname(dirname(dirname/dirname(dirname(/' phabricator/bin/*

# Custom preamble which forces HTTPS
cp preamble.php phabricator/support/preamble.php

