# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

FROM jenkins/jenkins:2.73.3
MAINTAINER Olaolu Akinsete
LABEL build_tag=com.maryboye.video/redis:v0.1


# setup log folder
USER root
RUN mkdir /var/log/jenkins
# give jenkins user write permission via ownership
RUN mkdir /var/cache/jenkins
RUN chown -R  jenkins:jenkins /var/log/jenkins
# or
#RUN install -d -o jenkins -g jenkins -m 0770 /var/log/jenkins
RUN chown -R jenkins:jenkins /var/cache/jenkins

USER jenkins

ENV JAVA_OPTS="-Xmx8192m \
    -Djava.util.logging.config.file=/var/jenkins_home/log.properties \
    -Dhudson.footerURL=http://maryboye.com"
ENV JENKINS_OPTS="--handlerCountMax=300 --logfile=/var/log/jenkins/jenkins.log"