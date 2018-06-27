FROM centos/php-71-centos7

USER root

# Install Pygments for syntax highlighting
# Install nss_wrapper and openssh-server for SSH and Git
RUN yum install -y --setopt=tsflags=nodocs python-pygments openssh-server nss_wrapper && yum clean all -y

# Copy scripts
COPY ./scripts/ /opt/app-root/etc/

USER 1001
