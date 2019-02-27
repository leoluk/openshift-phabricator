# openshift-phabricator

Opinionated, fully-functional Phabricator instance on OpenShift.

This role is used in production at multiple companies.

    oc new-project phab

    oc process -f openshift/phabricator.yaml \
      PHAB_BASE_HOST=phabricator.svc.example.com \
      PHAB_FILE_HOST=phabricator-cdn.svc.example.com \
      PHAB_SSH_PORT=30022 \
      | oc create -f -
      
    oc adm policy add-scc-to-user anyuid -z default
    oc process -f openshift/phabricator-sshd.yaml \
      PHAB_SSH_PORT=30022 \
      | oc create -f      

If you want SSH repository hosting, you will need to assign your Phabricator project
the `anyuid` permission. The sshd server needs to run as root inside the container
(see #7 - we don't currently support deployment without anyuid, but it's an easy fix).

The variable `PHAB_SSH_HOST` is optional, if no host is provided the
`PHAB_BASE_HOST` will be used for SSH. This setting can be used to choose a
different domain for SSH e.g. if you are protecting the `PHAB_BASE_HOST` with CloudFlare.

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
  - Optional: Sourcegraph integration

Next steps:

  - If your router does not have a wildcard default certificate 
    or you're deploying Phabricator on a custom domain, you need to
    attach a valid certificate to the routes. A number of features
    do not work with a self-signed certificate.

  - If you want Phabricator to send mails, configure the mailer:
    https://secure.phabricator.com/book/phabricator/article/configuring_outbound_email/

# Sourcegraph

This role optionally deploys a single-node Sourcegraph instance and integrates it with Phabricator.
While the Phabricator setup is fully automated, this one requires some manual configuration.

Deploy sourcegraph:

    oc process -f openshift/sourcegraph.yaml \
      SOURCEGRAPH_FRONTEND_HOST=sourcegraph.svc.example.com \
      SOURCEGRAPH_MGMT_HOST=sourcegraph-mgmt.svc.example.com

You will also need to set extra variables for the main deployment
(`PHAB_INSTALL_SOURCEGRAPH` and `PHAB_SOURCEGRAPH_HOST`):

    oc process -f openshift/phabricator.yaml \
      PHAB_BASE_HOST=phabricator.svc.example.com \
      PHAB_FILE_HOST=phabricator-cdn.svc.example.com \
      PHAB_INSTALL_SOURCEGRAPH=true \
      PHAB_SOURCEGRAPH_HOST=https://sourcegraph.svc.example.com \
      PHAB_SSH_PORT=30022 \
      | oc create -f -

By default, the deployment is set up to authenticate against OpenShift itself.
You will need to configure authentication in the Sourcegraph Management Console:

    {
      "auth.providers": [
        {
          "type": "http-header",
          "usernameHeader": "X-Forwarded-User"
        }
      ]
    }

After logging in via OpenShift, you'll have to revert to using `builtin` auth,
log in via the static admin user, promote your OpenShift to site admin, then
revert back to `http-header` auth. This appears to be a limitation in Sourcegraph.

Optionally set up SSH authentication to a third party Git server 
(via `oc rsh dc/sourcegraph`, persisted to the configuration volume):

    mkdir /etc/sourcegraph/ssh
    
    # populate known_hosts
    ssh-keyscan -t rsa -p 2222 git.example.com>> /etc/sourcegraph/ssh/known_hosts
    
    # private key
    cat <<EOF > /etc/sourcegraph/ssh/id_rsa
    <insert private key>
    EOF
    
    # SSH config
    cat <<EOF > /etc/sourcegraph/ssh/config
    Host git.example.com
    Port 2222
    User git
    EOF
    
    # restart container
    kill -TERM -1

See upstream docs for complete setup instructions:

- https://docs.sourcegraph.com/admin/external_service/phabricator
- https://github.com/sourcegraph/phabricator-extension
