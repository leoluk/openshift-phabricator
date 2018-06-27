# openshift-phabricator

Example repository on how to deploy a fully-functional Phabricator instance on OpenShift.

    oc process -f openshift/phabricator.yaml \
      PHAB_BASE_HOST=phabricator.svc.example.com \
      PHAB_FILE_HOST=phabricator-cdn.svc.example.com \
      | oc create -f -

Delete everything:

    oc delete all,pvc,secret,configmap -l app=phabricator

Working:

  - Phabricator itself
  - phd daemons
  - Aphlict notification server

Missing:

  - Git repository hosting

Next steps:

  - If your router does not have a wildcard default certificate 
    or you're deploying Phabricator on a custom domain, you need to
    attach a valid certificate to the routes. A number of features
    do not work with a self-signed certificate.

  - If you want Phabricator to send mails, configure the mailer:
    https://secure.phabricator.com/book/phabricator/article/configuring_outbound_email/

