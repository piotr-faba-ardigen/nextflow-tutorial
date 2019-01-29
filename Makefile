TAG=rnatoy
VERSION=latest
REGISTRY=nextflow

all: build push

build:
	docker build -t $(TAG) -f Dockerfile .
	docker tag $(TAG) $(REGISTRY)/$(TAG):$(VERSION)

push:
	docker push $(REGISTRY)/$(TAG):$(VERSION)

pull:
	docker pull $(REGISTRY)/$(TAG):$(VERSION)