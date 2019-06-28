# Base on official docker in docker image
FROM docker:18.09-dind 

RUN apk update && apk add \
    openjdk8 \
    bash \
    vim \
    make \
    python3 \
    python3-dev \
    --no-cache g++ \
    wget \
    py-virtualenv

WORKDIR /root

# Install nextflow
RUN wget -qO- https://get.nextflow.io | bash

ENV PATH=/root:$PATH

CMD ["/bin/bash"]