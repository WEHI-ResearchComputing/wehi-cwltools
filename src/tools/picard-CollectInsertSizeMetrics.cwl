#!/usr/bin/env cwl-runner

$namespaces:
  dct: http://purl.org/dc/terms/
  foaf: http://xmlns.com/foaf/0.1/
  doap: http://usefulinc.com/ns/doap#
  adms: http://www.w3.org/ns/adms#
  dcat: http://www.w3.org/ns/dcat#

$schemas:
- http://dublincore.org/2012/06/14/dcterms.rdf
- http://xmlns.com/foaf/spec/20140114.rdf
- http://usefulinc.com/ns/doap#
- http://www.w3.org/ns/adms#
- http://www.w3.org/ns/dcat.rdf

cwlVersion: v1.0
class: CommandLineTool

adms:includedAsset:
  doap:name: picard
  doap:description: 'A set of Java command line tools for manipulating high-throughput
    sequencing data (HTS) data and formats. Picard is implemented using the HTSJDK
    Java library HTSJDK, supporting accessing of common file formats, such as SAM
    and VCF, used for high-throughput sequencing data. http://broadinstitute.github.io/picard/command-line-overview.html#BuildBamIndex

    '
  doap:homepage: http://broadinstitute.github.io/picard/
  doap:repository:
  - class: doap:GitRepository
    doap:location: https://github.com/broadinstitute/picard.git
  doap:release:
  - class: doap:Version
    doap:revision: '1.141'
  doap:license: MIT, Apache2
  doap:category: commandline tool
  doap:programming-language: JAVA
  doap:developer:
  - class: foaf:Organization
    foaf:name: Broad Institute
doap:name: picard-MarkDuplicates.cwl
dcat:downloadURL: https://github.com/common-workflow-language/workflows/blob/master/tools/picard-MarkDuplicates.cwl
dct:creator:
- class: foaf:Organization
  foaf:name: UNIVERSITY OF MELBOURNE
  foaf:member:
  - class: foaf:Person
    id: farahk@student.unimelb.edu.au
    foaf:mbox: mailto:farahk@student.unimelb.edu.au
  - class: foaf:Person
    id: skanwal@student.unimelb.edu.au
    foaf:mbox: mailto:skanwal@student.unimelb.edu.au
requirements:
- $import: picard-env.yml
- class: InlineJavascriptRequirement

inputs:

  INPUT:
    type: File
    inputBinding:
      prefix: INPUT=
      separate: false
      position: 99
    doc: One or more input SAM or BAM files to analyze. Must be coordinate sorted.
      Default value null. This option may be specified 0 or more times

  HISTOGRAM_FILE:
    type: string
    inputBinding:
      prefix: HISTOGRAM_FILE=
      separate: false
      position: 99
    doc: File to write insert size Histogram chart to.  Required.

  DEVIATIONS:
    type: double?
    inputBinding:
      separate: false
      prefix: DEVIATIONS=
      position: 99
    doc: |
      Generate mean, sd and plots by trimming the data down to MEDIAN +
      DEVIATIONS*MEDIAN_ABSOLUTE_DEVIATION. This is done because insert size data typically
      includes enough anomalous values from chimeras and other artifacts to make the mean and
      sd grossly misleading regarding the real distribution.  Default value: 10.0. This option
      can be set to 'null' to clear the default value.

  HISTOGRAM_WIDTH:
    type: int?
    inputBinding:
      separate: false
      prefix: HISTOGRAM_WIDTH=
      position: 99
    doc: |
      Explicitly sets the Histogram width, overriding automatic truncation of Histogram tail.
      Also, when calculating mean and standard deviation, only bins <= Histogram_WIDTH will be
      included.  Default value: null.

  MINIMUM_PCT:
    type: float?
    inputBinding:
      separate: false
      prefix: MINIMUM_PCT=
      position: 99
    doc: |
      When generating the Histogram, discard any data categories (out of FR, TANDEM, RF) that
      have fewer than this percentage of overall reads. (Range: 0 to 1).  Default value: 0.05.
      This option can be set to 'null' to clear the default value.

  METRIC_ACCUMULATION_LEVEL:
    type:
      - "null"
      - type: enum
        symbols: ['ALL_READS', 'SAMPLE', 'LIBRARY', 'READ_GROUP']
    inputBinding:
      separate: false
      prefix: METRIC_ACCUMULATION_LEVEL=
      position: 99
    doc: |
      The level(s) at which to accumulate metrics.    Default value: [ALL_READS]. This option
      can be set to 'null' to clear the default value. Possible values: {ALL_READS, SAMPLE,
      LIBRARY, READ_GROUP} This option may be specified 0 or more times. This option can be set
      to 'null' to clear the default list.

  INCLUDE_DUPLICATES:
    type: boolean?
    inputBinding:
      separate: false
      prefix: INCLUDE_DUPLICATES=TRUE
      position: 99
    doc: |
      The maximum offset between two duplicte clusters in order to consider them
      optical duplicates. This should usually be set to some fairly small number (e.g.
      5-10 pixels) unless using later versions of the Illumina pipeline that multiply
      pixel values by 10, in which case 50-100 is more normal. Default value 100.
      This option can be set to 'null' to clear the default value

  TMP_DIR:
    type: string?
    inputBinding:
      separate: false
      prefix: TMP_DIR=
      position: 99
    doc: |
      If true, also include reads marked as duplicates in the insert size histogram.  Default
      value: false. This option can be set to 'null' to clear the default value. Possible
      values: {true, false}

  java_arg:
    type: string
    default: -Xmx10g
    inputBinding:
      position: 1

  ASSUME_SORTED:
    type: boolean?
    inputBinding:
      separate: false
      prefix: ASSUME_SORTED=TRUE
      position: 99
    doc: |
      If true (default), then the sort order in the header file will be ignored.  Default
      value: true. This option can be set to 'null' to clear the default value. Possible
      values: {true, false}

  STOP_AFTER:
    type: int?
    inputBinding:
      separate: false
      prefix: STOP_AFTER=
      position: 99
    doc: |
      Stop after processing N reads, mainly for debugging.  Default value: 0. This option can
      be set to 'null' to clear the default value.

  VERBOSITY:
    type:
      - "null"
      - type: enum
        symbols: ['ERROR', 'WARNING', 'INFO', 'DEBUG']
    inputBinding:
      separate: false
      prefix: VERBOSITY=
      position: 99
    doc: |
      Control verbosity of logging.  Default value: INFO. This option can be set to 'null' to
      clear the default value. Possible values: {ERROR, WARNING, INFO, DEBUG}

  QUIET:
    type: boolean?
    inputBinding:
      separate: false
      prefix: QUIET=TRUE
      position: 99
    doc: |
      Whether to suppress job-summary info on System.err.  Default value: false. This option
      can be set to 'null' to clear the default value. Possible values: {true, false}

  VALIDATION_STRINGENCY:
    type:
    - "null"
    - type: enum
      symbols: ['STRICT', 'LENIENT', 'SILENT']
    inputBinding:
      separate: false
      prefix: VALIDATION_STRINGENCY=
      position: 99
    doc: |
      Validation stringency for all SAM files read by this program.  Setting stringency to
      SILENT can improve performance when processing a BAM file in which variable-length data
      (read, qualities, tags) do not otherwise need to be decoded.  Default value: STRICT. This
      option can be set to 'null' to clear the default value. Possible values: {STRICT,
      LENIENT, SILENT}

  COMPRESSION_LEVEL:
    type: int?
    inputBinding:
      separate: false
      prefix: COMPRESSION_LEVEL=
      position: 99
    doc: |
      Compression level for all compressed files created (e.g. BAM and GELI).  Default value:
      5. This option can be set to 'null' to clear the default value.

  MAX_RECORDS_IN_RAM:
    type: int?
    inputBinding:
      separate: false
      prefix: MAX_RECORDS_IN_RAM=
      position: 99
    doc: |
      When writing SAM files that need to be sorted, this will specify the number of records
      stored in RAM before spilling to disk. Increasing this number reduces the number of file
      handles needed to sort a SAM file, and increases the amount of RAM needed.  Default
      value: 500000. This option can be set to 'null' to clear the default value.

  CREATE_INDEX:
    type: boolean?
    inputBinding:
      separate: false
      prefix: CREATE_INDEX=
      position: 99
    doc: |
      Whether to create a BAM index when writing a coordinate-sorted BAM file.  Default value:
      false. This option can be set to 'null' to clear the default value. Possible values:
      {true, false}

  CREATE_MD5_FILE:
    type: boolean?
    inputBinding:
      separate: false
      prefix: CREATE_MD5_FILE=
      position: 99
    doc: |
      Whether to create an MD5 digest for any BAM or FASTQ files created.    Default value:
      false. This option can be set to 'null' to clear the default value. Possible values:
      {true, false}

  REFERENCE_SEQUENCE:
    type: boolean?
    inputBinding:
      separate: false
      prefix: REFERENCE_SEQUENCE=
      position: 99
    doc: |
      Reference sequence file.  Default value: null.

  GA4GH_CLIENT_SECRETS:
    type: string?
    inputBinding:
      separate: false
      prefix: GA4GH_CLIENT_SECRETS=
      position:: 99
    doc: |
      Google Genomics API client_secrets.json file path.  Default value: client_secrets.json.
      This option can be set to 'null' to clear the default value.

  OPTIONS_FILE:
    type: File?
    inputBinding:
      separate: false
      prefix: OPTIONS_FILE=
      position: 99
    doc: |
      File of OPTION_NAME=value pairs.  No positional parameters allowed.  Unlike command-line
      options, unrecognized options are ignored.  A single-valued option set in an options file
      may be overridden by a subsequent command-line option.  A line starting with '#' is
      considered a comment.  Required.

  OUTPUT:
    type: string
    inputBinding:
      separate: false
      prefix: OUTPUT=
      position: 99
    doc: File to write the output to.  Required.

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.OUTPUT)
  histogram:
    type: File
    outputBinding:
      glob: $(inputs.HISTOGRAM_FILE)

baseCommand: ['java']
arguments:
- valueFrom: picard.analysis.CollectInsertSizeMetrics
  position: 2

