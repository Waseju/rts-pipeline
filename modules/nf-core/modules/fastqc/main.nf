// Import generic module functions
include { initOptions; saveFiles; getSoftwareName } from './functions'

params.options = [:]
options        = initOptions(params.options)

process FASTQC {
    tag "15"
    label 'process_low'
    publishDir "${params.outdir}",
        mode: params.publish_dir_mode,
        saveAs: { filename -> saveFiles(filename:filename, options:params.options, publish_dir:getSoftwareName(task.process), meta:meta, publish_by_meta:['id']) }

    conda (params.enable_conda ? "bioconda::fastqc=0.11.9" : null)
    if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
        container "https://depot.galaxyproject.org/singularity/fastqc:0.11.9--0"
    } else {
        container "ghcr.io/waseju/rts:latest"
    }

    input:
    path(reads)

    output:
    
    //tuple val(meta), path("*.html"), emit: html
    //tuple val(meta), path("*.zip") , emit: zip
    //path  "*.version.txt"          , emit: version

    script:
    // Add soft-links to original FastQs for consistent naming in pipeline
    def software = getSoftwareName(task.process)
    //def prefix   = options.suffix ? "${meta.id}${options.suffix}" : "${meta.id}"
    """
    rts_package -i inputs
    """

}
