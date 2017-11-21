log:
	docker stop jenkins-master
	docker cp jenkins-master:/var/log/jenkins/jenkins.log jenkins.log
	cat jenkins.log
	
check:
	docker exec jenkins-master ps -ef | grep java