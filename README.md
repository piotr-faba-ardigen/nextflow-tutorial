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

# Task 3

In this task you add another stage to your pipeline called `mapping`. In result you should have a 2 stage pipeline that firstly indexes the genome and then maps the indexed genome obtained bam files.

1. Create channel that contains read pairs (i.e. pairs of fastq files) as in `(ggal_gut_1.fq, ggal_gut_2.fq)`. See documentation for [Channel factory](https://www.nextflow.io/docs/latest/channel.html?highlight=fromfilepairs#channel-factory) and [fromFilePairs](https://www.nextflow.io/docs/latest/channel.html?highlight=fromfilepairs#fromfilepairs).

2. Create `mapping` process

3. Define 2 inputs:
    * accept genome index from previous stage
    * accept reads from read pairs channel with something like: `set pair_id, file(reads) from read_pairs`

4. Add command to be executed: `tophat2 genome.index ${reads}`

5. `tophat2` by default creates results in `tophat_out/`. We are interested in `tophat_out/accepted_hits.bam`. Rename this file by using `pair_id` 

6. The result should be published in the `results` folder. 

# Task 4

In this task you add last stage to your pipeline called `makeTranscript`. In result you should have a 3 stage pipeline that takes genome and produces transcripts.

1. Modify `mapping` to not to rename the `tophat_out/accepted_hits.bam` output any more.

2. Modify `mapping` to construct (`pair_id`, bam_file) tuple and push it to `bam_files` channel. Refer to [set operator](https://www.nextflow.io/docs/latest/operator.html#set).

3. Create `makeTranscript` process

4. Construct input to accept `pair_id` and `bam_file` from the `bam_files` in the same way as it was created.

5. Run `cufflinks` tool on each `bam_file` without any additional arguments.

6. Rename the resulting `transcripts.gtf` to `transcript_${pair_id}.gtf`

7. The result should be published in the `results` folder. 