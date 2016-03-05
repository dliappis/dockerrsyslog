IMAGE ?= dliappis/dockerrsyslog
TESTIMAGE1 = hello-world
TESTIMAGE2 = jsonlogger
TAG = latest

.PHONY: %

all: build push
build: build-local
run: run-local
stop: stop-docker
clean: stop-docker clean-images cleanup-dirs
updateconf: signal-rsyslog-SIGHUP
reload: reload-rsyslog
test: cleanup-dirs reload-rsyslog test1 test2

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

signal-rsyslog-%:
	docker kill --signal=$* $$(docker ps | grep -i $(IMAGE) | awk '{print $$1}')

reload-rsyslog: signal-rsyslog-SIGTERM run-local

test1:
	docker run --log-driver=syslog --log-opt tag=$(TESTIMAGE1) --log-opt syslog-address=tcp://127.0.0.1:1514 hello-world
	test -f rsyslog/$(TESTIMAGE1).log

test2:
	cd docker-compose.d/jsonlogger && make run
	test -f rsyslog/$(TESTIMAGE2).log
	export IFS=$$'\n'; for i in $$(cat rsyslog/$(TESTIMAGE2).log); do echo $$i | python -m json.tool; done

# docker-tag-%:
#         docker tag -f $(IMAGE):latest $(IMAGE):$*

# docker-push-%: docker-tag-%
#         docker push $(IMAGE):$*

# # Shortcut for latest
# docker-push: docker-push-latest
