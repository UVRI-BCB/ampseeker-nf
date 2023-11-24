#!/usr/bin/env nextflow
nextflow.enable.dsl=2

process bcl_convert {

    input:
        path(sample_csv)
        path(illumina_indir)

    output:
        path("reads_dir"), emit: reads_dir
        path("fastq_list.csv"), emit: fastq_list

    """
    bcl-convert \
        --bcl-input-directory ${illumina_indir} \
        --output-directory reads_dir \
        --sample-sheet ${sample_csv} \
        --force 
    """
}

process rename_fastq {

    input:
        path(reads) 
        path(fastq_list)

    output:
        path("*.fastq.gz"), emit: renamed_fastq_ch 
    
    """
    while IFS="," read -r _ sample_id _ _ read1 read2; do
        
        if [[ $sample_id == "RGSM" ]]; then
            continue
        fi
        
        echo renaming $read1 and $read2 to ${{sample_id}}_1.fastq.gz and ${{sample_id}}_2.fastq.gz 
        mv $read1 ${{sample_id}}_1.fastq.gz
        mv $read2 ${{sample_id}}_2.fastq.gz
    done < ${fastq_list}
    """
}