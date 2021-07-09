
build:
	docker build -t nextflow/project-base -f docker/project-base/Dockerfile docker/project-base/

pull:
	docker pull nextflow/rnatoy:1.3
	docker tag nextflow/rnatoy:1.3 nextflow/rnatoy:latest
	docker pull ardigenpiotr/project-base:latest
	docker tag ardigenpiotr/project-base:latest nextflow/project-base:latest

run_pipeline:
	nextflow run main.nf

run_project_image:
	docker run \
	-v $(CURDIR):$(CURDIR) \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-it nextflow/project-base \
	/bin/bash -c "cd $(CURDIR) && /bin/bash"

run:
	docker run \
	-v $(CURDIR):$(CURDIR) \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-it nextflow/project-base \
	/bin/bash -c "cd $(CURDIR) && make run_pipeline"
