#!/bin/bash
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
# Clean up old stuff BE CAREFUL WHERE YOU RUN THIS
sudo rm -rf testlogs run
mkdir -p run/rsyslog
docker rmi dliappis/dockerrsyslog:1
docker build -t dliappis/dockerrsyslog:1 .
docker run -p 1514:1514 -v $PWD/testlogs:/var/log/rsyslog -v $PWD/run/rsyslog:/var/run/rsyslog dliappis/dockerrsyslog:1
