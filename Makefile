log:
	docker stop jenkins-master
	docker cp jenkins-master:/var/log/jenkins/jenkins.log jenkins.log
	cat jenkins.log

check:
	docker exec jenkins-master ps -ef | grep java

build:
    @docker-compose -p jenkins build

run:
    @docker-compose -p jenkins up -d nginx data master

stop:
    @docker-compose -p jenkins stop

clean:    stop
    @docker-compose -p jenkins rm master nginx

clean-data: clean
    @docker-compose -p jenkins rm -v data

clean-images:
    @docker rmi `docker images -q -f "dangling=true"`