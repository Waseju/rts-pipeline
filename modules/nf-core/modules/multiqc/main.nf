// Import generic module functions
include { initOptions; saveFiles; getSoftwareName } from './functions'

params.options = [:]
options        = initOptions(params.options)

process MULTIQC {
    //tag "$meta.id"
    label 'process_medium'
    publishDir "${params.outdir}",
        mode: params.publish_dir_mode,
        saveAs: { filename -> saveFiles(filename:filename, options:params.options, publish_dir:getSoftwareName(task.process), meta:[:], publish_by_meta:[]) }
    container "ghcr.io/waseju/fiji:latest"

    input:
    path input

    output:
    //path "*multiqc_report.html", emit: report
    path("*ratios") , emit: ratios
    path("*brightfields") , emit: brightfields

    script:
    def software = getSoftwareName(task.process)
    """
    cp /opt/fiji/ratio_macro.ijm ./
    mkdir output
    xvfb-run -a /opt/fiji/Fiji.app/ImageJ-linux64 --run ratio_macro.ijm 'inDir="$input/",outDir="output/"'
    mkdir ratios
    mkdir brightfields
    mv output/*_ratio.tif ratios/
    mv output/*.tif brightfields/
    """
}
