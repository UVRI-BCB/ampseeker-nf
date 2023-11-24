

process bwa_index {

    input:
    ref=path(params.ref)

    output:
    path(*), emit: bwa_idx

    """
    bwa index ${ref}
    """
}

process bwa_align {

    input:
    tuple val(sample), path(reads)
    path(bwa_idx)

    output:
    tuple val(sample), path("${sample}.bam"), emit: align_ch

    """
    bwa mem ${bwa_idx} ${reads} | samtools sort -o ${sample}.bam
    """

}

process samtools_index {

    input:
    align_ch
    
    output:
    path("${sample}.bam.bai")

    """
    samtools index ${align_ch.} ${sample}.bam.bai
    """

}