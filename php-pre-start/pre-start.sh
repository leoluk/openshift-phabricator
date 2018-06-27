#!/bin/bash

echo "Setting global config..."
phabricator/bin/config set mysql.host ${DATABASE_SERVICE_HOST}
phabricator/bin/config set mysql.user ${DATABASE_SERVICE_USER}
phabricator/bin/config set mysql.pass ${DATABASE_SERVICE_PASSWORD}

phabricator/bin/config set repository.default-local-path ${APP_ROOT}/repositories
phabricator/bin/config set storage.local-disk.path ${APP_ROOT}/files

if [[ -z $APHLICT_HOST ]]; then
  echo "APHLICT_HOST not set, skipping"
else
  phabricator/bin/config set notification.servers '[
  {
    "type": "client",
    "host": "'${APHLICT_HOST}'",
    "port": 443,
    "protocol": "https"
  },
  {
    "type": "admin",
    "host": "'${APHLICT_SERVICE}'",
    "port": 22281,
    "protocol": "http"
  }
]'
fi

echo "Running database migrations..."
phabricator/bin/storage upgrade --force

