params.reads = 

/*
 * Step 1. Print each record
 */
process printSequences {
 
    input:
    
 
    output:
    
 
    """
    awk '{if(NR%4==2) print \$0}' input.fq
    """
 
}

/*
 * print the channel content
 */
result.subscribe { println it }