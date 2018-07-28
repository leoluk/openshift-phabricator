FROM centos/php-71-centos7

USER root

# Install Pygments for syntax highlighting
# Install nss_wrapper and openssh-server for SSH and Git
RUN yum install -y --setopt=tsflags=nodocs python-pygments openssh-server nss_wrapper ImageMagick && yum clean all -y

# Copy scripts
COPY ./scripts/ /opt/app-root/etc/

# Wrap Git and SSH to make nss_wrapper with with phd
COPY ./scripts/nss_wrapper /opt/app-root/bin/git
COPY ./scripts/nss_wrapper /opt/app-root/bin/ssh

# Custom SSH config
COPY ./sshd_config /etc/ssh/sshd_config
COPY ./sshd_env /etc/sysconfig/sshd
COPY ./scripts/phabricator-ssh-hook /usr/local/bin/phabricator-ssh-hook

# VCS user for repo hosting
RUN useradd -u 1002 -M -g 0 -p NP -s /bin/sh repo

USER 1001
