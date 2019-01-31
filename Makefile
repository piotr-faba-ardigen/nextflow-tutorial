TAG=rnatoy
VERSION=latest
REGISTRY=nextflow

build:
	docker build -t $(TAG) -f Dockerfile .
	docker tag $(TAG) $(REGISTRY)/$(TAG):$(VERSION)

pull:
	docker pull $(REGISTRY)/$(TAG):1.3
	docker tag $(REGISTRY)/$(TAG):1.3 $(REGISTRY)/$(TAG):$(VERSION)

run:
	nextflow run main.nf