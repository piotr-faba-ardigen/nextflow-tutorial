RNA-Seq tutorial
======================

Build a proof of concept of a RNA-Seq pipeline intended to show Nextflow
scripting and reproducibility capabilities.

# Prerequisits


1) Install Docker on your computer. Read more here https://docs.docker.com/

2) Install Nextflow (version 0.24.x or higher)

    `curl -fsSL get.nextflow.io | bash`

3) Pull the required Docker image as shown below: 

    `make pull`

    or build one

    `make build`

# Task 1

1. Create a `nextflow.config` basic based on [documentation](https://www.nextflow.io/docs/latest/config.html#configuration-file) that includes:
    * **enables docker by default**, otherwise nextflow will try to execute all processes in your local environment
    * indicates what container to use (`nextflow/rnatoy:latest`)
    * indicates that reports from execution are created by default in `reports/report.html`

    The file is started for you.

2. Create `main.nf` based on [nextflow basic example](https://www.nextflow.io/example1.html) that takes both [`data/ggal_gut_1.fa`,`data/ggal_gut_2.fa`] and prints each record in standard output in one process.

    The file is started for you.

# Task 2

1. Start building RnaSeq pipeline by modifying `main.fa` to have 1 stage called `buildIndex`.
    For the provided genome: `/data/ggal/ggal_1_48850000_49020000.Ggal71.500bpflank.fa`, build index with the following bowtie command:

    ```
        bowtie2-build ${genome} genome.index
    ```

2. The result should be published in the `results` folder. See reference for [publishDir](https://www.nextflow.io/docs/latest/process.html?highlight=publishdir#publishdir) directive.
