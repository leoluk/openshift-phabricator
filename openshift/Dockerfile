FROM centos/php-71-centos7

USER root

# Install Pygments for syntax highlighting
RUN yum install -y --setopt=tsflags=nodocs python-pygments openssh-server && yum clean all -y

USER 1001
