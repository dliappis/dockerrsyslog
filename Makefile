IMAGE ?= dliappis/dockerrsyslog
TESTIMAGE = hello-world
TAG = latest

.PHONY: %

all: build push
build: build-local
run: run-local
stop: stop-docker
clean: stop-docker clean-images cleanup-dirs
updateconf: update-running-rsyslog

stop-docker:
	-docker stop $$(docker ps -a | grep -i $(IMAGE) | awk '{print $$1}')
	-docker rm $$(docker ps -a | grep -i $(IMAGE)  | awk '{print $$1}')

clean-images:
	-docker rmi $$(docker images | grep -i $(IMAGE)  | awk '{print $$3}')

cleanup-dirs:
#Ensure we are in the build dir before attempting any rm -rf !
	if grep -q rsyslog .git/config; then \
		sudo rm -rf rsyslog; \
	fi

build-local: stop-docker cleanup-dirs
	docker build -t $(IMAGE):$(TAG) .

run-local:
	docker run -d -p 1514:1514 -v $$PWD/etc:/etc/rsyslog:ro -v $$PWD/rsyslog:/var/log/rsyslog $(IMAGE):$(TAG) -n -f /etc/rsyslog/rsyslog.conf

docker-push:
	docker push $(IMAGE)

test:
	docker run --log-driver=syslog --log-opt tag=$(TESTIMAGE) --log-opt syslog-address=tcp://127.0.0.1:1514 hello-world
	test -f rsyslog/$(TESTIMAGE).log

update-running-rsyslog:
	docker kill --signal=SIGHUP $$(docker ps | grep -i $(IMAGE) | awk '{print $$1}')
# docker-tag-%:
#         docker tag -f $(IMAGE):latest $(IMAGE):$*

# docker-push-%: docker-tag-%
#         docker push $(IMAGE):$*

# # Shortcut for latest
# docker-push: docker-push-latest
