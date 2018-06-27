# openshift-phabricator

Example repository on how to deploy a fully-functional Phabricator instance on OpenShift.

    oc process -f openshift/phabricator.yaml | oc create -f -
    oc env dc/phabricator APHLICT_HOST=$(oc get route phabricator-aphlict -o json | jq -r .spec.host)

Working:

  - Phabricator itself
  - phd daemons
  - Aphlict notification server

Missing:

  - Git repository hosting
