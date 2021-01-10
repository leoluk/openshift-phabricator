#!/bin/bash

echo "Setting global config..."
phabricator/bin/config set mysql.host ${DATABASE_SERVICE_HOST}
phabricator/bin/config set mysql.user ${DATABASE_SERVICE_USER}
phabricator/bin/config set mysql.pass ${DATABASE_SERVICE_PASSWORD}

phabricator/bin/config set repository.default-local-path ${APP_ROOT}/repositories
phabricator/bin/config set storage.local-disk.path ${APP_ROOT}/files

phabricator/bin/config set pygments.enabled true
phabricator/bin/config set files.enable-imagemagick true
phabricator/bin/config set security.strict-transport-security true
phabricator/bin/config set security.require-https true

phabricator/bin/config set phabricator.base-uri https://${PHAB_BASE_HOST}
phabricator/bin/config set security.alternate-file-domain https://${PHAB_FILE_HOST}

if [[ -z $PHAB_SSH_HOST ]]
then
    PHAB_SSH_HOST="${PHAB_BASE_HOST}"
fi

phabricator/bin/config set diffusion.ssh-host ${PHAB_SSH_HOST}
phabricator/bin/config set diffusion.ssh-port ${PHAB_SSH_PORT}
phabricator/bin/config set diffusion.ssh-user repo
phabricator/bin/config set phd.user default

phabricator/bin/config set notification.servers '[
  {
    "type": "client",
    "host": "'${PHAB_BASE_HOST}'",
    "path": "/ws",
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

echo "Running database migrations..."
phabricator/bin/storage upgrade --force

if [ "${PHAB_INSTALL_SOURCEGRAPH}" = "true" ]; then
    echo "Rebuilding assets..."
    phabricator/bin/celerity map
fi
