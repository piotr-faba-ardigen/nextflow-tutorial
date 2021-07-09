RNA-Seq tutorial
======================

Build a proof of concept of a RNA-Seq pipeline intended to show Nextflow
scripting and reproducibility capabilities.

# Prerequisits

## IDE
Visual Code Studio IDE - this is recommended IDE for working with Nextflow.

Additionally install the following extensions:

1. Nextflow
2. Docker

## Docker

Two docker images will be used in this experiment:
1. `nextflow/project-base` is container to unify our working environments. It is able to execute nextflow.
2. `nextflow/rnatoy` is a container that can contains simple rna-seq processing tools. It will be used to perform processing.

Pull the required Dockers with: 

    `make pull`

or build one of them with:

    `make build`

# Start

Checkout git tag `task1-checkpoint` to set your repository in the starting point.

You can use:

`git checkout -b my-solution task1-checkpoint`

This will create branch `my-solution` for you on which you can commit your steps.

# Task 1

1. Create a `nextflow.config` basic based on [documentation](https://www.nextflow.io/docs/latest/config.html#configuration-file) that includes:
    * **enables docker by default**, otherwise nextflow will try to execute all processes in your local environment
    * indicates what container to use (`nextflow/rnatoy:latest`)
    * indicates that reports from execution are created by default in `reports/report.html`

    The file is started for you.

2. Create `main.nf` based on [nextflow basic example](https://www.nextflow.io/example1.html) that takes both [`data/ggal/ggal_gut_1.fq`,`data/ggal/ggal_gut_2.fq`] and prints each record in standard output in one process.

    The file is started for you.

3. Use `make run` to execute the pipeline.

In result after running the pipeline, in terminal you should see loads of DNA lines similar to those below.

```
...
GGCGTAGCCACCAACTGCTTGACGACTTCATTTCCAAAAAGCAGGATTTAATGAGTCTGGAGCACAAGTCTTATGAGGAGCAGCTGAGGGAACTGGGATTGCTTA
GGTTGGCCTCTTTTCCCACATAACTAGCAGTAGGACTAGAGGGGATGGCCTCAGTTTCGCGGCAGGGAAGATTCAGGTTGGGTGTTAGGAAAAGTTTCTCTGAAA
GAGGAGGGTCAGGCACTGGAATGGGCTGCCCAGGGTGGTGGAGTCACCATCCCTGTTGGGGATCAAGAAACATTTCACTGTGGTACTGAGGGATGTGGTTTAGTG
GGGGAGAGTCGGGTTGGGTGTTAGGAAAAGTTTCTCTGAAAGGGATGGTCAGGCACTGGAATGGGCTGCCCAGGGTGGTGGAGTCACCATCCCTGTTGGGGATCA
GGATGGCCTCAGTTTCGCGGCAGGGAAGATTCAGGTTGGGTGTTAGGAAAAGTTTCTCTGAAAGGGATGGTCAGGCACTGGAATGGGCTGCCCAGGGTGGTGGAG
...

```

If you have trouble achieving this effect, check the solution by checking out, the starting point for task 2. Checkout `task2-checkpoint` and execute `make run`. If you achieved this, you can just progress to the next task.

# Task 2

1. Start building RnaSeq pipeline by modifying `main.nf` to have 1 stage called `buildIndex`.
    For the provided genome: `data/ggal/ggal_1_48850000_49020000.Ggal71.500bpflank.fa`, build index with the following bowtie command:

    ```
        bowtie2-build ${genome} genome.index
    ```

2. The result should be published in the `results` folder. See reference for [publishDir](https://www.nextflow.io/docs/latest/process.html?highlight=publishdir#publishdir) directive. 

3. Run the pipeline. You should see 6 files appear in the `results` folder:

```
genome.index.1.bt2  
genome.index.2.bt2  
genome.index.3.bt2  
genome.index.4.bt2  
genome.index.rev.1.bt2  
genome.index.rev.2.bt2
```

If you have trouble achieving this effect, check the solution by checking out, the starting point for the next task. Checkout `task3-checkpoint` and execute `make run`. If you achieved this, you can just progress to the next task.

# Task 3

In this task you add another stage to your pipeline called `mapping`. In result you should have a 2 stage pipeline that firstly indexes the genome and then maps the indexed genome obtained bam files.

1. Create channel that contains read pairs (i.e. pairs of fastq files) as in `(ggal_gut_1.fq, ggal_gut_2.fq)`. See documentation for [Channel factory](https://www.nextflow.io/docs/latest/channel.html?highlight=fromfilepairs#channel-factory) and [fromFilePairs](https://www.nextflow.io/docs/latest/channel.html?highlight=fromfilepairs#fromfilepairs).

2. Create `mapping` process

3. Define 2 inputs:
    * accept genome index from previous stage
    * accept reads from read pairs channel with something like: `set pair_id, file(reads) from read_pairs`

4. Add command to be executed: `tophat2 genome.index ${reads}`

5. `tophat2` by default creates results in `tophat_out/`. We are interested in `tophat_out/accepted_hits.bam`. Rename this file by using `pair_id` to `$pair_id.bam`.

6. The result should be published in the `results` folder. 

7. Run the pipeline. You should see 2 files appear in the `results/tophat_oout` folder:

```
ggal_gut.bam
ggal_liver.bam
```

If you have trouble achieving this effect, check the solution by checking out, the starting point for the next task. Checkout `task4-checkpoint` and execute `make run`. If you achieved this, you can just progress to the next task.

# Task 4

In this task you add last stage to your pipeline called `makeTranscript`. In result you should have a 3 stage pipeline that takes genome and produces transcripts.

1. Modify `mapping` to construct (`pair_id`, bam_file) tuple and push it to `bam_files` channel. Refer to [set operator](https://www.nextflow.io/docs/latest/operator.html#set).

2. Create `makeTranscript` process

3. Construct input to accept `pair_id` and `bam_file` from the `bam_files` in the same way as it was created.

4. Run `cufflinks` tool on each `bam_file` without any additional arguments.

5. Rename the resulting `transcripts.gtf` to `transcript_${pair_id}.gtf`

6. The result should be published in the `results` folder. 

7. Run the pipeline. You should see 2 files appear in the `results` folder:

```
transcript_ggal_gut.gtf
transcript_ggal_liver.gtf
```

If you have trouble achieving this effect, check the solution by checking out, the starting point for the next task. Checkout `task5-checkpoint` and execute `make run`. If you achieved this, you can just progress to the next task.

# Task 5*

This task is additional for eager participants. It's all about refining your outputs and communication to the user.

1. Tag the processes that run in parallel to display which read pair they are processing. See [documentation](https://www.nextflow.io/docs/latest/tracing.html).

2. Display a message at the end of the workflow about whether it was successful or not. See [documentation](https://www.nextflow.io/docs/latest/metadata.html?highlight=workflow#completion-handler).

3. Investigate the report that is being generated on each run. See [Tracing and visualisation](https://www.nextflow.io/docs/latest/tracing.html) section of documentation to see what other reports can be generated. Try generating them.

4. Limit the memory on mapping to 2 MB on `mapping` process with [process selector](https://www.nextflow.io/docs/latest/config.html#process-selectors), and define retries with higher memory so the pipeline passes by using [dynamic computing resources](https://www.nextflow.io/docs/latest/process.html?highlight=memory#dynamic-computing-resources).


Partial solution can be found by checking out the `final-solution-checkpoint` tag.

## Additional resources

See other tutorials to learn more:
1. [Lifebit tutorial](https://github.com/lifebit-ai/lbf-hack-tutorial) includes introduction to FlowCraft tool and Deploit web interface for running pipelines.
2. [NF-Hack 2017](https://github.com/nextflow-io/nf-hack17-tutorial) tutorial written by author of Nextflow, Paolo Di Tommaso, introduces usage of Singularity containers instead of Docker.
