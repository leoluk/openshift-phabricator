#!/bin/bash

# Confusion due to symlinks in the path
sed -i "s%^\$root =.*$%\$root = '${APP_ROOT}/src/phabricator';%" phabricator/bin/*

# SSH won't know about our fancy PATH override
sed -i '1 s%^.*$%#!/opt/rh/rh-php71/root/usr/bin/php%' phabricator/bin/ssh-exec

# Custom preamble which forces HTTPS
cp preamble.php phabricator/support/preamble.php

# Disable opcache revalidation
sed -i 's/opcache.validate_timestamps=.*/opcache.validate_timestamps=0/' ${APP_ROOT}/etc/php.d/10-opcache.ini.template

# Install Sourcegraph extension
if [ "${PHAB_INSTALL_SOURCEGRAPH}" = "true" ]; then
    echo "Installing Sourcegraph extension..."

    git clone -b ${SOURCEGRAPH_GIT_REF} ${SOURCEGRAPH_GIT_REPO} phabricator/src/extensions/sourcegraph

    (
        cd phabricator/src/extensions/sourcegraph
        if [[ "$(git rev-parse HEAD)" != "${SOURCEGRAPH_GIT_PIN}" ]]; then
            echo "Wrong HEAD revision for Sourcegraph extension"
            exit 1
        fi
    ) || exit 1
fi
