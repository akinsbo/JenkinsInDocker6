docker stop jenkins-master
docker rm jenkins-master
#docker run -p 8081:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home --name=jenkins-master -d --env JAVA_OPTS="-Xmx8192m" -Dhudson.footerURL=http://maryboye.com  jenkins/jenkins:2.73.3
#docker run -p 8081:8080 -v ./JENKINS_HOME:/var/jenkins_home --name=jenkins-master -d --env JAVA_OPTS="-Xmx8192m" jenkins



#mkdir data
#cat > data/log.properties <<EOF
#handlers=java.util.logging.ConsoleHandler
#jenkins.level=FINEST
#java.util.logging.ConsoleHandler.level=FINEST
#EOF
docker run \
--name jenkins-master \
-p 8081:8080 \
-p 50001:50000 \
--env JAVA_OPTS=\
"-Djava.util.logging.config.file=/var/jenkins_home/log.properties \
-Dhudson.footerURL=http://maryboye.com \
-Xmx8192m" \
--env JENKINS_OPTS="--handlerCountMax=300" \
-v `pwd`/data:/var/jenkins_home \
-d \
jenkins/jenkins:2.73.3