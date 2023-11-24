
#!/usr/bin/env nextflow
nextflow.enable.dsl=2

process fastqc {
  input:
  tuple val(sample_id), path(reads)
  
  output:
  tuple val(sample_id), path("fastqc_out"), emit: fastqc_ch
 
  script:
  """
  mkdir fastqc_out
  fastqc ${reads} -o fastqc_out
  """
}

process multiqc {

    input:
    path(qc_dir)
    
    output:
    tuple path("multiqc_report.html"), path("multiqc_data"), emit: multiqc_ch
    
    """
    multiqc ${qc_dir} --force
    """
}

process fastp {

  input:
  tuple val(sample_id), path(reads)
  
  output:
  tuple val(sample_id), path(".fq.gz"), emit: fastp_ch
  
  script:
  """
  fastp \
   -i ${reads[0]} \
   -I ${reads[1]} \
   -o ${sample_id}_R1.fq.gz \
   -O ${sample_id}_R2.fq.gz
  """
}
