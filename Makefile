log:
	docker stop jenkins-master
	docker cp jenkins-master:/var/log/jenkins/jenkins.log jenkins.log
	cat jenkins.log

check:
	docker exec jenkins-master ps -ef | grep java

build:
	@docker-compose build
run:
	@docker-compose up -d
stop:
	@docker-compose stop
clean:	stop
	@docker-compose rm jenkinsmaster jenkinsnginx
clean-data: clean
	@docker-compose rm -v jenkinsdata
clean-images:
	@docker rmi $(docker images -q --filter="dangling=true")