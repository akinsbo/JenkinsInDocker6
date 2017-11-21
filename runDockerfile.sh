#run data container
docker stop jenkins-data
docker rm jenkins-data
docker build -t myjenkinsdata:v0.1 jenkins-data/.
docker run --name=jenkins-data myjenkinsdata:v0.1

docker cp jenkins-data:/var/log/jenkins/jenkins.log jenkins.log

#run master
docker stop jenkins-master
docker rm jenkins-master
docker build -t myjenkins:v0.1 jenkins-master/.
docker run \
-p 8082:8080 -p 50002:50000 \
--name=jenkins-master \
--volumes-from=jenkins-data \
-d \
myjenkins:v0.1
# with the container working, we tail the logfile
docker exec jenkins-master ls /var/log/jenkins
# display initial password in console
docker exec jenkins-master cat /var/jenkins_home/secrets/initialAdminPassword


# run nginx
docker build -t myjenkinsnginx jenkins-nginx/.
docker run --name=jenkins-data myjenkinsdata