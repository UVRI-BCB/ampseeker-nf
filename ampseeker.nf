#!/usr/bin/env nextflow
nextflow.enable.dsl=2

params.workflow  = null
params.genome    = null
params.genes     = null
params.data      = null
params.outdir    = null
params.singleEnd = null
params.pairedEnd = null
params.trim      = null

workflow         = params.workflow

// USER INPUT WORKFLOW: WHICH ANALYSIS TO RUN!
switch (workflow) {
    case [null]:
        exit 1, workflow_error(workflow)

    case ["bcl-convert"]:
        include {  } from './modules/bcl_convert.nf'
        break

    case ["read-qc"]:
        include { } from './modules/qc.nf'
        break

    case ["alignment"]:
        include {  } from './modules/alignment.nf'
        break
    
    case ["variant-calling"]:
        include {  } from './modules/variant_calling.nf'
        break

    case ["analysis"]:
        include {  } from './modules/analysis.nf'
        break

    default:
        exit 1, workflow_error(workflow)
}

// convert bcl to fastq files
workflow BCL_CONVERT {

}

//  perform quality control
workflow READ_QC {
    
}

// align reads to reference genome
workflow READ_ALIGNMENT {

}

//
workflow VARIANT_CALLING {
 
}

workflow {
    switch (workflow) {
        case [null]:
            exit 1, workflow_error(workflow)
        case ['bcl-convert']:
            BCL_CONVERT()
            break
        case['read-qc']:
            READ_QC(samples)
            break
        case['alignment']:
            READ_ALIGNMENT(samples)
            break
        case['analysis']:
            VARIANT_CALLING(bams)
            break
        default:
            exit 1, workflow_error(workflow)
            break
    }
}