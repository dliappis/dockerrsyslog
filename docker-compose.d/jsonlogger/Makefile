IMAGE ?= jsonlogger

.PHONY: %

build: build-local
run: run-local
stop: stop-docker
clean: stop-docker clean-images

stop-docker:
	-docker stop $$(docker ps -a | grep -i $(IMAGE) | awk '{print $$1}')
	-docker rm $$(docker ps -a | grep -i $(IMAGE)  | awk '{print $$1}')

clean-images:
	-docker rmi $$(docker images | grep -i $(IMAGE)  | awk '{print $$3}')

build-local: stop-docker clean-images
	docker build -t $(IMAGE) .

run-local:
	docker run --log-driver=syslog --log-opt tag=$(IMAGE) --log-opt syslog-address=tcp://127.0.0.1:1514 $(IMAGE)
