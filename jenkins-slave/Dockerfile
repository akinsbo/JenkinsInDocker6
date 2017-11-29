FROM debian:stretch
MAINTAINER Olaolu Akinsete

ENV JAVA_VERSION 8u151
ENV JAVA_DEBIAN_VERSION 8u151-b12-1~deb9u1
ENV CA_CERTIFICATES_JAVA_VERSION 20170531+nmu1

# openssh-server - necessary so that Jenkins can reach out and connect to our running slave container
RUN apt-get update && apt-get install -y --no-install-recommends \
                git \
		openssh-server \
                openjdk-8-jdk="$JAVA_DEBIAN_VERSION" \
		wget \
                && rm -rf /var/lib/apt/lists/*


# Set SSH Configuration to allow remote logins without /proc write access
RUN sed -ri 's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' /etc/pam.d/sshd

# Create Jenkins User
RUN useradd jenkins -m -s /bin/bash

## Add public key for Jenkins login
RUN mkdir /home/jenkins/.ssh
#Copy authorized keys to mactch key from Jenkins master when connection is made.
# This removes the need to create a password for this user, reducing risk on a
# large farm
COPY /files/authorized_keys /home/jenkins/.ssh/authorized_keys
RUN chown -R jenkins /home/jenkins \
    && chgrp -R jenkins /home/jenkins \
    && chmod 600 /home/jenkins/.ssh/authorized_keys \
    && chmod 700 /home/jenkins/.ssh


# Add the jenkins user to sudoers
RUN echo "jenkins ALL=(ALL) ALL" >> etc/sudoers

# Set Name Servers (just to make sure no problems as struggling to route
COPY /files/resolv.conf /etc/resolv.conf

# Expose SSH port 22 and run SSHD
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]