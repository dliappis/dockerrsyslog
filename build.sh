docker build -t dliappis/dockerrsyslog:1 .
docker run -p 1514:1514 -v $PWD/testlogs:/var/log dliappis/dockerrsyslog:1
