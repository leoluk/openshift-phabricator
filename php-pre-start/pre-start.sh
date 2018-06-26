#!/bin/bash

echo "Setting global config..."
phabricator/bin/config set mysql.host ${DATABASE_SERVICE_HOST}
phabricator/bin/config set mysql.user ${DATABASE_SERVICE_USER}
phabricator/bin/config set mysql.pass ${DATABASE_SERVICE_PASSWORD}

echo "Running database migrations..."
phabricator/bin/storage upgrade
