#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
- $import: gridss-env.yml
#- $import: samtools-docker.yml
- class: InlineJavascriptRequirement

inputs:
  INPUT:
    type:
      type: array
      items: File
      inputBinding:
        prefix: INPUT=
        separate: false
    doc: |
      Input libraries. Specify multiple times (ie INPUT=file1.bam INPUT=file2.bam INPUT=file3.bam ) to process multiple libraries together.
      Input files must be coordinated sorted SAM/BAM/CRAM files.
      GRIDSS considers all reads in each file to come from a single library.
      Input files containing read groups from multiple different libraries should be split into an input file per-library.
      The reference genome used for all input files matches the reference genome supplied to GRIDSS.

  INPUT2:
    type:
      - "null"
      - type: array
        items: File
        inputBinding:
          prefix: INPUT=
          separate: false
    doc: |
      The same as INPUT but allows a fixed comparison

  INPUT_LABEL:
    type:
      - "null"
      - type: array
        items: string
        inputBinding:
          prefix: INPUT_LABEL=
          separate: false
    doc: |
      Labels to allocate inputs. The default label for each input file corresponds to the file name but can be overridden by specifying an
      INPUT_LABEL for each INPUT. The output any for INPUT files with the same INPUT_LABEL will be merged.

  INPUT_LABEL2:
    type:
      - "null"
      - type: array
        items: string
        inputBinding:
          prefix: INPUT_LABEL=
          separate: false
    doc: |
      The same as INPUT_LABEL but allows a fixed comparison

  WORKING_THREADS:
    type: int?
    inputBinding:
      prefix: WORKING_THREADS=
      separate: false
    doc: |
      Number of processing threads to use, including number of thread to use when invoking the aligner. Note that the number
      of threads spawned by GRIDSS is greater than the number of worker threads due to asynchronous I/O threads thus it is
      not uncommon to see over 100% CPU usage when WORKER_THREADS=1 as bam compression/decompression is a computationally
      expensive operation. This parameter defaults to the number of cores available.

  REFERENCE_SEQUENCE:
    type: string
    inputBinding:
      prefix: REFERENCE_SEQUENCE=
      separate: false
    doc: |
      Reference genome fasta file. GRIDSS requires the reference genome supplied exactly matches the reference genome all
      input files. The reference genome must be be fasta format and must have a tabix (.fai) index and an index for the
      NGS aligner (by default bwa). The NGS aligner index prefix must match the reference genome filename. For example,
      using the default setting against the reference file reference.fa, the following files must be present and readable:
            File             Description
        reference.fa      reference genome
        reference.fa.fai  Tabix index
        reference.fa.amb  bwa index
        reference.fa.ann  bwa index
        reference.fa.bwt  bwa index
        reference.fa.pac  bwa index
        reference.fa.sa   bwa index
      These can be created using samtools faidx reference.fa and bwa index reference.fa
      A .dict sequence dictionary is also required but GRIDSS will automatically create one if not found.

  INPUT_NAME_SORTED:
    type: File[]?
    inputBinding:
      prefix: INPUT_NAME_SORTED=
      separate: false
    doc: |
      Input libraries sorted in lexographical read name order. This parameter is required if any of the input libraries contain multiple
      alignment records for a single read ("multi-mapping reads"). Failure to supply a name sorted input file for mutli-mapping reads will
      result in an increased false discovery rate.

      Note that this sort order matches the Picard tools SortSam queryname sort order (which unfortuntely is not the same as the samtools
      name sort ordeR).

  ASSEMBLY:
    type: string
    inputBinding:
      prefix: ASSEMBLY=
      separate: false
    doc: |
      File to write breakend assemblies to. It is strongly recommended that the assembly filename correspond to the OUTPUT filename.
      Using ASSEMBLY=assembly.bam is probematic as (like the INPUT files) the assembly file is relative not to WORKING_DIR, but to
      the current directory of the calling process. This is likely to result in data corruption when the same assembly file name is
      used on different data sets (for example, writing assembly.bam to your home directory when running on a cluster).

  BLACKLIST:
    type: File?
    inputBinding:
      prefix: BLACKLIST=
      separate: false
    doc: |
      BED blacklist of regions to exclude from analysis. The ENCODE DAC blacklist is recommended when aligning against hg19.

      Unlike haplotype assemblers such as TIGRA and GATK, GRIDSS does not abort assembly when complex assembly graphs are
      encountered. Processing of these graphs slows down the assembly process considerably, so if regions such as telemeric
      and centromeric regions are to be excluded from downstream analysis anyway, assembly of these regions is not required.
      It is recommended that a blacklist such as the ENCODE DAC blacklist be used to filter such regions. Inclusion of additional
      mappability-based blacklists is not required as GRIDSS already considers the read mapping quality.

  READ_PAIR_CONCORDANT_PERCENT:
    type: float?
    inputBinding:
      prefix: READ_PAIR_CONCORDANT_PERCENT=
      separate: false
    doc: |
      Portion (0.0-1.0) of read pairs to be considered concordant. Concordant read pairs are considered to provide no support
      for structural variation. Clearing this value will cause GRIDSS to use the 0x02 proper pair SAM flag written by the aligner
      to detemine concordant pairing. Note that some aligners set this flag in a manner inappropriate for SV calling and set the
      flag for all reads with the expected orientation and strand regardless of the inferred fragment size.

  INPUT_MIN_FRAGMENT_SIZE:
    type: string[]?
    inputBinding:
      prefix: INPUT_MIN_FRAGMENT_SIZE=
      separate: false
    doc: |
      Per input overrides for explicitly specifying fragment size interval to be considered concordant. As with INPUT_LABEL,
      these must be specified for all input files. Use null to indicate an override is not required for a particular input
      (eg INPUT=autocalc.bam INPUT_MIN_FRAGMENT_SIZE=null INPUT_MAX_FRAGMENT_SIZE=null INPUT=manual.bam INPUT_MIN_FRAGMENT_SIZE=100
      INPUT_MAX_FRAGMENT_SIZE=300 )

  INPUT_MAX_FRAGMENT_SIZE:
    type: string[]?
    inputBinding:
      prefix: INPUT_MAX_FRAGMENT_SIZE=
      separate: false
    doc: |
      Per input overrides for explicitly specifying fragment size interval to be considered concordant. As with INPUT_LABEL,
      these must be specified for all input files. Use null to indicate an override is not required for a particular input
      (eg INPUT=autocalc.bam INPUT_MIN_FRAGMENT_SIZE=null INPUT_MAX_FRAGMENT_SIZE=null INPUT=manual.bam INPUT_MIN_FRAGMENT_SIZE=100
      INPUT_MAX_FRAGMENT_SIZE=300 )

  OUTPUT:
    type: string
    inputBinding:
      prefix: OUTPUT=
    doc: |
      Variant calling output file. Can be VCF or BCF.

outputs:
  vcf:
    type: File
    outputBinding:
      glob: $(inputs.OUTPUT)
  bam:
    type: File
    outputBinding:
      glob: $(inputs.OUTPUT.split('.').slice(0,-1).join('.')+'.bam')
  bam_working:
    type: Directory
    outputBinding:
      glob: $(inputs.OUTPUT.split('.').slice(0,-1).join('.')+'.bam.gridss.working')
  vcf_working:
    type: Directory
    outputBinding:
      glob: $(inputs.OUTPUT + '.gridss.working')

baseCommand: [java,
  -ea,
  -Xmx31g,
  -Dsamjdk.create_index=true,
  -Dsamjdk.use_async_io_read_samtools=true,
  -Dsamjdk.use_async_io_write_samtools=true,
  -Dsamjdk.use_async_io_write_tribble=true,
  gridss.CallVariants]


arguments:
- valueFrom: $('TMP_DIR='+runtime.outdir)
  position: 1
- valueFrom: $('WORKING_DIR='+runtime.outdir)
  position: 2
