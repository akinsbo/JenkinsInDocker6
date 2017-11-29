#  Debian image because it matches the same base image the Cloudbees Jenkins image
FROM debian:jessie
MAINTAINER Olaolu Akinsete

#we set the UID here to the same one the Cloudbees Jenkins image uses so we can
# match UIDs across containers, which is essential if you want to preserve file
# permissions between the containers. We also use the same home directory and
# bash settings.
# Create the jenkins user
RUN useradd -d "/var/jenkins_home" -u 1000 -m -s /bin/bash jenkins \
    && mkdir -p /var/log/jenkins \
    && chown -R jenkins:jenkins /var/log/jenkins
#mount the log folder
VOLUME ["/var/log/jenkins", "/var/jenkins_home"]

USER jenkins

CMD ["echo", "Data container for Jenkins"]