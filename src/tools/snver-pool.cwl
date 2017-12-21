#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
- $import: snver-env.yml
#- $import: samtools-docker.yml
- class: InlineJavascriptRequirement
- class: InitialWorkDirRequirement
  listing:
    - $(inputs.input_directory)

inputs:
  input_directory:
    type: Directory
    inputBinding:
      prefix: -i
    doc: |
      input directory (required)

  reference:
    type: File
    inputBinding:
      prefix: -r
    doc: |
      reference file (required)

  pool_info:
    type: File?
    inputBinding:
      prefix: -c
    doc: |
      pool info file (preferred)

  haploids:
    type: int?
    inputBinding:
      prefix: -n
    doc: |
      the number of haploids (required when option "-c" is not given)

  target_region:
    type: File?
    inputBinding:
      prefix: -l
    doc: |
      target region bed file (default is null)

  output_prefix:
    type: File?
    inputBinding:
      prefix: -o
    doc: |
      prefix output file (default is input_file name)

  mapping_quality_threshold:
    type: float?
    inputBinding:
      prefix: -mq
    doc: |
      mapping quality threshold (default is 20)

  base_quality_threshold:
    type: float?
    inputBinding:
      prefix: -bq
    doc: |
      base quality threshold (default is 17)

  strand_bias_threshold:
    type: float?
    inputBinding:
      prefix: -s
    doc: |
      strand bias threshold (default is 0.0001)

  fisher_threshold:
    type: float?
    inputBinding:
      prefix: -f
    doc: |
      fisher exact threshold (default is 0.0001)

  p_value_threshold:
    type: float?
    inputBinding:
      prefix: -p
    doc: |
      p-value threshold (default is bonferroni=0.05

  allele_read_threshold:
    type: int?
    inputBinding:
      prefix: -t
    doc: |
      allele frequency threshold (default is 0)

  allele_frequency_threshold:
    type: float?
    inputBinding:
      prefix: -b
    doc: |
      discard locus with ratio of alt/ref below the threshold (default is 0.25)

  inactivate_threshold:
    type: float?
    inputBinding:
      prefix: -u
    doc: |
      inactivate -s and -f above this threshold (default is 30)

  dbsnp_path:
    type: File?
    inputBinding:
      prefix: -db
    doc: |
      path for dbSNP, column number of chr, pos and snp_id (format: dbsnp,1,2,3; default null)

outputs:
  vcf:
    type: File[]
    outputBinding:
      glob: '*.vcf'
  log:
    type: File
    outputBinding:
      glob: '*.log'

baseCommand: [
  java,
  -Xmx8g,
  net.sf.snver.pileup.SNVerPool
]
