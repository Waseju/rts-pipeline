params.options = [:]

include { SAMPLESHEET_CHECK } from '../../modules/local/samplesheet_check' addParams( options: params.options )

workflow INPUT_CHECK {
    take:
    samplesheet

    main:
    SAMPLESHEET_CHECK ( samplesheet )
        //.splitCsv ( header:true, sep:',' )
        //.map { create_fastq_channels(it) }
        .set { reads }

    emit:
    reads // channel: [ val(meta), [ reads ] ]
}

// Function to get list of [ meta, [ fastq_1, fastq_2 ] ]
def create_fastq_channels(LinkedHashMap row) {
    def meta = [:]
    meta.id           = "15"
    meta.single_end   = "x"

    def array = []

    array = [ meta, [] ]
    return meta
}
