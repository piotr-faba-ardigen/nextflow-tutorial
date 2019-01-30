params.reads = "$baseDir/data/ggal/ggal_gut_{1,2}.fq"
sequences = file(params.reads) 

/*
 * Step 1. Print each record
 */
process printSequences {
 
    input:
    file 'input.fq' from sequences
 
    output:
    stdout result
 
    """
    awk '{if(NR%4==2) print \$0}' input.fq
    """
 
}

/*
 * print the channel content
 */
result.subscribe { println it }
