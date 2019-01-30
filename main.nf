params.reads = "$baseDir/data/ggal/*_{1,2}.fq"
params.genome = "$baseDir/data/ggal/ggal_1_48850000_49020000.Ggal71.500bpflank.fa"
   
/*
 * The reference genome file
 */
genome_file = file(params.genome)
  
/*
 * Creates the `read_pairs` channel that emits for each read-pair a tuple containing
 * three elements: the pair ID, the first read-pair file and the second read-pair file
 */
read_pairs = Channel.fromFilePairs( params.reads )                                             

/*
 * Step 1. Builds the genome index required by the mapping process
 */
process buildIndex {
    tag "$genome_file.baseName"

    input:
    file genome from genome_file
      
    output:
    file 'genome.index*' into genome_index
        
    """
    bowtie2-build ${genome} genome.index
    """
}


/*
 * Step 2. Maps each read-pair by using Tophat2 mapper tool
 */
process mapping {
    tag "$pair_id"
    input:
    file index from genome_index
    set pair_id, file(reads) from read_pairs
  
    output:
    set pair_id, "tophat_out/${pair_id}.bam" into bam_files
  
    """
    tophat2 genome.index ${reads}
    mv tophat_out/accepted_hits.bam tophat_out/${pair_id}.bam
    """
}

/*
 * Step 3. Assembles the transcript by using the "cufflinks" tool
 */
process makeTranscript {
    tag "$pair_id"
    publishDir "results"

    input:
    set pair_id, file(bam_file) from bam_files
     
    output:
    file('transcript_*.gtf') into transcripts
 
    """
    cufflinks $bam_file
    mv transcripts.gtf transcript_${pair_id}.gtf
    """
}

 
workflow.onComplete { 
	println ( workflow.success ? "Done!" : "Oops .. something went wrong" )
}