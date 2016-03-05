IMAGE ?= dliappis/dockerrsyslog
TAG = latest

.PHONY: %

all: local push
local: build-local
run: run-local
clean: stop-docker cleanup-dirs

stop-docker:
	docker stop $$(docker ps -a | grep -i $(IMAGE) | awk '{print $$1}')
	docker rm $$(docker ps -a | grep -i $(IMAGE)  | awk '{print $$1}')
	docker rmi $$(docker images | grep -i $(IMAGE)  | awk '{print $$3}')

cleanup-dirs:
#Ensure we are in the build dir before attempting any rm -rf !
	if grep -q rsyslog .git/config; then \
		sudo rm -rf rsyslog; \
	fi

build-local: stop-docker cleanup-dirs
	docker build -t $(IMAGE):$(TAG) .

run-local:
	docker run -d -p 1514:1514 -v $$PWD/rsyslog:/var/log/rsyslog $(IMAGE):$(TAG)

docker-push:
	docker push $(IMAGE)

# docker-tag-%:
#         docker tag -f $(IMAGE):latest $(IMAGE):$*

# docker-push-%: docker-tag-%
#         docker push $(IMAGE):$*

# # Shortcut for latest
# docker-push: docker-push-latest
