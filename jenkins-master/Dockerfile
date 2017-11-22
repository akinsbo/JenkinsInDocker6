FROM debian:stretch
MAINTAINER Olaolu Akinsete

ENV JAVA_VERSION 8u151
ENV JAVA_DEBIAN_VERSION 8u151-b12-1~deb9u1
ENV CA_CERTIFICATES_JAVA_VERSION 20170531+nmu1

RUN apt-get update && apt-get install -y --no-install-recommends \
		curl \
                ca-certificates \
                ca-certificates-java="$CA_CERTIFICATES_JAVA_VERSION" \
                git \
		mercurial \
		openssh-client \
                openjdk-8-jdk="$JAVA_DEBIAN_VERSION" \
                unzip \
		wget \
                zip \
                && rm -rf /var/lib/apt/lists/*

RUN /var/lib/dpkg/info/ca-certificates-java.postinst configure

# Install tini
ENV TINI_VERSION 0.14.0
ENV TINI_SHA 6c41ec7d33e857d4779f14d9c74924cab0c7973485d2972419a3b7c7620ff5fd
# Use tini as subreaper in Docker container to adopt zombie processes 
RUN curl -fsSL https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static-amd64 -o /bin/tini && chmod +x /bin/tini \
  && echo "$TINI_SHA  /bin/tini" | sha256sum -c -



# set environmental variables
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG http_port=8080
ARG agent_port=50000

 #jenkins version being bundled in this docker image
ARG JENKINS_VERSION
ENV JENKINS_VERSION ${JENKINS_VERSION:-2.73.3}

# jenkins.war checksum, download will be validated using it
ARG JENKINS_SHA=2d71b8f87c8417f9303a73d52901a59678ee6c0eefcf7325efed6035ff39372a
# Can be used to customize where jenkins.war get downloaded from
RUN echo ${JENKINS_VERSION}

ARG JENKINS_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war
RUN echo ${JENKINS_URL}

ENV JENKINS_HOME /var/jenkins_home
ENV JENKINS_SLAVE_AGENT_PORT ${agent_port}
ENV JENKINS_UC https://updates.jenkins.io
ENV JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental
ENV COPY_REFERENCE_FILE_LOG $JENKINS_HOME/copy_reference_file.logs
#set memory with Xmx and get rid of admin password setup with runSetup = false
ENV JAVA_OPTS="-Xmx8192m \
    -Djava.util.logging.config.file=/var/jenkins_home/log.properties \
    -Dhudson.footerURL=http://maryboye.com \
    -Djenkins.install.runSetupWizard=false"
ENV JENKINS_OPTS="--handlerCountMax=300 \
    --logfile=/var/log/jenkins/jenkins.log \
    --webroot=/var/cache/jenkins/war"


# Jenkins is run with user `jenkins`, uid = 1000
# If you bind mount a volume from the host or a data container,
# ensure you use the same uid
# Jenkins is run with user `jenkins`, uid = 1000
# If you bind mount a volume from the host or a data container, 
# ensure you use the same uid
RUN groupadd -g ${gid} ${group} \
    && useradd -d "$JENKINS_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}
# Jenkins home directory is a volume, so configuration and build history
# can be persisted and survive image upgrades
VOLUME /var/jenkins_home
# `/usr/share/jenkins/ref/` contains all reference configuration we want
# to set on a fresh new installation. Use it to bundle additional plugins
# or config file with your custom jenkins Docker image.
RUN mkdir -p /usr/share/jenkins/ref/init.groovy.ds
# could use ADD but this one does not check Last-Modified header neither does it allow to control checksum 
# see https://github.com/docker/docker/issues/8331
RUN curl -fsSL ${JENKINS_URL} -o /usr/share/jenkins/jenkins.war \
  && echo "${JENKINS_SHA}  /usr/share/jenkins/jenkins.war" | sha256sum -c -

# Prep Jenkins Directories
RUN chown -R ${user} "$JENKINS_HOME" /usr/share/jenkins/ref
RUN mkdir /var/log/jenkins
# give jenkins user write permission via ownership
RUN mkdir /var/cache/jenkins
RUN chown -R  jenkins:jenkins /var/log/jenkins
# or RUN install -d -o jenkins -g jenkins -m 0770 /var/log/jenkins
RUN chown -R jenkins:jenkins /var/cache/jenkins

#Expose Ports for web and slave agents
# for main web interface:
EXPOSE ${http_port}
# will be used by attached slave agents:
EXPOSE ${agent_port}

#Switch to the jenkins user
USER jenkins

# Set Tini as the entry point to manage zombie processes
ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/jenkins.sh"]

COPY jenkins-support /usr/local/bin/jenkins-support
COPY jenkins.sh /usr/local/bin/jenkins.sh

# from a derived Dockerfile, can use `RUN plugins.sh active.txt` to setup /usr/share/jenkins/ref/plugins from a support bundle
COPY plugins.sh /usr/local/bin/plugins.sh
COPY install-plugins.sh /usr/local/bin/install-plugins.sh

# `/usr/share/jenkins/ref/` contains all reference configuration we want 
# to set on a fresh new installation. Use it to bundle additional plugins 
# or config file with your custom jenkins Docker image.
RUN mkdir -p /usr/share/jenkins/ref/init.groovy.d
COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/tcp-slave-agent-port.groovy
