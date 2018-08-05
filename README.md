# openshift-phabricator

Example repository on how to deploy a fully-functional Phabricator instance on OpenShift.

    oc new-project phab

    oc process -f openshift/phabricator.yaml \
      PHAB_BASE_HOST=phabricator.svc.example.com \
      PHAB_FILE_HOST=phabricator-cdn.svc.example.com \
      PHAB_SSH_PORT=30022 \
      | oc create -f -

The variable `PHAB_SSH_HOST` is optional, if no host is provided the
`PHAB_BASE_HOST` will be used for SSH. This setting can be used to choose a
different domain for SSH e.g. if you are protecting the `PHAB_BASE_HOST` with CloudFlare.

If you want SSH repository hosting, you will need to assign your Phabricator project
the `anyuid` permission. The sshd server needs to run as root inside the container.

    oc adm policy add-scc-to-user anyuid -z default
    oc process -f openshift/phabricator-sshd.yaml \
      PHAB_SSH_PORT=30022 \
      | oc create -f

This will create a nodePort for SSH on port 30022. You can override the default port
with the `NODE_PORT` template variable. If you don't want to use a node port, you can
assign an `ExternalIP` (see OpenShift docs) or even tunnel SSH via the router.

Delete everything:

    oc delete all,pvc,secret,configmap -l app=phabricator

Working:

  - Phabricator itself
  - phd daemons
  - Aphlict notification server
  - SSH repository hosting (tested with Git)

Next steps:

  - If your router does not have a wildcard default certificate 
    or you're deploying Phabricator on a custom domain, you need to
    attach a valid certificate to the routes. A number of features
    do not work with a self-signed certificate.

  - If you want Phabricator to send mails, configure the mailer:
    https://secure.phabricator.com/book/phabricator/article/configuring_outbound_email/

