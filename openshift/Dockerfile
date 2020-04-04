FROM centos/php-71-centos7

USER root

# Install EPEL for latest pygments version
RUN yum install -y --setopt=tsflags=nodocs epel-release

# Install openssh-server for SSH and Git
RUN yum install -y --setopt=tsflags=nodocs \
    python36-pygments \
    openssh-server \
    ImageMagick \
    rsyslog \
    sudo \
    sendmail \
    mariadb \
    && yum clean all -y

# Phabricator wants pygmentize
RUN ln -s /usr/bin/pygmentize-3.6 /usr/bin/pygmentize

# Copy scripts
COPY ./scripts/ /opt/app-root/etc/

# Custom SSH config
COPY ./sshd_config /etc/ssh/sshd_config
COPY ./sshd_env /etc/sysconfig/sshd
COPY ./scripts/phabricator-ssh-hook /usr/local/bin/phabricator-ssh-hook
COPY ./sudoers /etc/sudoers

# VCS user for repo hosting
RUN useradd -g 0 -u 1002 -M -d /opt/app-root/src -p NP -s /bin/sh repo

USER 1001
