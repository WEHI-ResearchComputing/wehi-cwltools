#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
- $import: samtools-env.yml
- class: InlineJavascriptRequirement
- class: InitialWorkDirRequirement
  listing: [ $(inputs.inputFile) ]

inputs:
  inputFile:
    type: File
    inputBinding:
      position: 99
    doc: |
      Tabix indexes a TAB-delimited genome position file in.tab.bgz and creates an index file ( in.tab.bgz.tbi or in.tab.bgz.csi )
      when region is absent from the command-line.

  zero-based:
    type: boolean?
    inputBinding:
      prefix: --zero-based
    doc: |
      -0, --zero-based Specify that the position in the data file is 0-based (e.g. UCSC files) rather than 1-based.

  begin:
    type: int?
    inputBinding:
      prefix: --begin
    doc: |
      -b, --begin INT Column of start chromosomal position. [4]

  comment:
    type: string?
    inputBinding:
      prefix: --comment
    doc: |
      -c, --comment CHAR skip lines started with character CHAR. [#]

  csi:
    type: boolean?
    inputBinding:
      prefix: --csi
    doc: |
      -C, --csi Produce CSI format index instead of classical tabix or BAI style indices.

  end:
    type: int?
    inputBinding:
      prefix: --end
    doc: |
      -e, --end INT Column of end chromosomal position. The end column can be the same as the start column. [5]

  force:
    type: boolean?
    inputBinding:
      prefix: --force
    doc: |
      -f, --force Force to overwrite the index file if it is present.

  min-shift:
    type: int?
    inputBinding:
      prefix: --min-shift
    doc: |
      -m, --min-shift INT set minimal interval size for CSI indices to 2^INT [14]

  preset:
    type:
      - "null"
      - type: enum
        symbols: [gff, bed, sam, vcf]
    inputBinding:
      prefix: --preset
    doc: |
      -p, --preset STR Input format for indexing. Valid values are: gff, bed, sam, vcf. This option should not
      be applied together with any of -s, -b, -e, -c and -0; it is not used for data retrieval because this
      setting is stored in the index file. [gff]

  sequence:
    type: int?
    inputBinding:
      prefix: --sequence
    doc: |
      -s, --sequence INT Column of sequence name. Option -s, -b, -e, -S, -c and -0 are all stored in the index
      file and thus not used in data retrieval. [1]

  skip-lines:
    type: int?
    inputBinding:
      prefix: --skip-lines
    doc: |
      -S, --skip-lines INT Skip first INT lines in the data file. [0]

  print-header:
    type: boolean?
    inputBinding:
      prefix: --print-header
    doc: |
      -h, --print-header Print also the header/meta lines.

  only-header:
    type: boolean?
    inputBinding:
      prefix: --only-header
    doc: |
      -H, --only-header Print only the header/meta lines.

  list-chroms:
    type: boolean?
    inputBinding:
      prefix: --list-chroms
    doc: |
      -l, --list-chroms List the sequence names stored in the index file.

  reheader:
    type: File?
    inputBinding:
      prefix: --reheader
    doc: |
      -r, --reheader FILE Replace the header with the content of FILE

  regions:
    type: File?
    inputBinding:
      prefix: --regions
    doc: |
      -R, --regions FILE Restrict to regions listed in the FILE. The FILE can be BED file (requires .bed, .bed.gz, .bed.bgz
      file name extension) or a TAB-delimited file with CHROM, POS, and, optionally, POS_TO columns, where positions are
      1-based and inclusive. When this option is in use, the input file may not be sorted. regions.

  targets:
    type: File?
    inputBinding:
      prefix: --targets
    doc: |
      -T, --targets FILE Similar to -R but the entire input will be read sequentially and regions not listed in FILE
      will be skipped.

outputs:
  tabix:
#     type: File
#     outputBinding:
#       glob: $(inputs.inputFile.path).tbi

# indexed_vcf:
    type: File
    secondaryFiles: .tbi
    outputBinding:
        glob: $(inputs.inputFile.basename)

baseCommand: [tabix]
