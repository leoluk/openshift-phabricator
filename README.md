# openshift-phabricator

Example repository on how to deploy a fully-functional Phabricator instance on OpenShift.

    oc process -f openshift/phabricator.yaml \
      PHAB_BASE_HOST=phabricator.svc.example.com \
      PHAB_FILE_HOST=phabricator-cdn.svc.example.com \
      | oc create -f -

Working:

  - Phabricator itself
  - phd daemons
  - Aphlict notification server

Missing:

  - Git repository hosting

