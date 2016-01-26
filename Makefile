DOCKER = docker
ENV = $(shell cat .dockeropts)
REPO = quay.io/aptible/logstash

TAG = $(shell git rev-parse --abbrev-ref HEAD 2>/dev/null)
ifeq ($(TAG), master)
	TAG = latest
else ifeq ($(TAG), HEAD)
	TAG = latest
endif

all: release

run: build
	$(DOCKER) run $(ENV) $(REPO)

release: build
	$(DOCKER) push $(REPO)

build:
	sed "s|#__RUN_TESTS__#|RUN bats /tmp/test|g" < Dockerfile > Dockerfile.test
	$(DOCKER) build -f Dockerfile.test -t $(REPO):$(TAG) .
	rm Dockerfile.test
