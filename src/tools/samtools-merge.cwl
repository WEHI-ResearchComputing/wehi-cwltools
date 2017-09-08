#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
- $import: samtools-env.yml
- class: InlineJavascriptRequirement

inputs:
  input:
    type: File[]
    inputBinding:
      position: 99
    doc: |
      Input bam files

  outputFile:
    type: string
    inputBinding:
      position: 98
    doc: |
      output file name

  sorted:
    type: boolean?
    inputBinding:
      prefix: -n
    doc: |
      -n Input files are sorted by read name

  sort-tag:
    type: string?
    inputBinding:
      prefix: -t
    doc: |
      -t TAG     Input files are sorted by TAG value

  attach_rg_tag:
    type: boolean?
    inputBinding:
      prefix: -r
    doc: |
      -r Attach RG tag (inferred from file names)

  uncompressed:
    type: boolean?
    inputBinding:
      prefix: -u
    doc: |
      -u Uncompressed BAM output

  compression-level:
    type: int?
    inputBinding:
      prefix: -l
    doc: |
      -l INT     Compression level, from 0 to 9 [-1]

  region:
    type: string?
    inputBinding:
      prefix: -R
    doc: |
      -R STR     Merge file in the specified region STR [all]

  header-file:
    type: File?
    inputBinding:
      prefix: -h
    doc: |
      -h FILE    Copy the header in FILE to <out.bam> [in1.bam]

  combine-rg-headers:
    type: boolean?
    inputBinding:
      prefix: -c
    doc: |
      -c         Combine @RG headers with colliding IDs [alter IDs to be distinct]

  combine-pg-headers:
    type: boolean?
    inputBinding:
      prefix: -p
    doc: |
      -p         Combine @PG headers with colliding IDs [alter IDs to be distinct]

  seed:
    type: int?
    inputBinding:
      prefix: -s
    doc: |
      -s VALUE   Override random seed

  filelist:
    type: File?
    inputBinding:
      prefix: -b
    doc: |
      -b FILE    List of input BAM filenames, one per line [null]

  threads:
    type: int?
    inputBinding:
      prefix: -@
    doc: Set number of sorting and compression threads [1]


outputs:
  merge:
    type: File
    outputBinding:
      glob: $(inputs.outputFile)
    doc: The index file

baseCommand: [samtools, merge]
