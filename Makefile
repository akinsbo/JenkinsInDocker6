log:
	docker stop jenkins-master
	docker cp jenkins-master:/var/log/jenkins/jenkins.log jenkins.log
	cat jenkins.log

check:
	docker exec jenkins-master ps -ef | grep java

# -p is the set-project-name option which we set to "jenkins"
build:
	@docker-compose -p jenkins build
run:
	@docker-compose -p jenkins up -d nginx data master

stop:
	@docker-compose -p jenkins stop

clean:
	@docker-compose -p jenkins rm master nginx

clean-data:
	@docker-compose -p jenkins rm -v data

clean-images:
	@docker rmi `docker images -q -f "dangling=true"`