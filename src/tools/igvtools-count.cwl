#!/usr/bin/env cwl-runner


cwlVersion: v1.0
class: CommandLineTool

requirements:
- $import: igvtools-env.yml
- class: InlineJavascriptRequirement

inputs:
  inputFile:
    type: File
    inputBinding:
      position: 100
    doc: |
      The input file (see supported formats above).

  outputFileName:
    type: string
    inputBinding:
      position: 101
    doc: |
      Either a binary tdf file, a text wig file, or both.  The output file type is determined
       by file extension, for example "output.tdf".  To output both formats supply two file names
       separated by a commas,  for example  "outputBinary.tdf,outputText.wig". To display feature
       intensity in IGV, the density must be computed with this command, and the resulting file
       must be named <feature track filename>.tdf.
       The special string "stdout" can be used in either position, in which case the output will
       be written to the standard output stream in wig format.

  genome:
    type: File?
    inputBinding:
      position: 102
    doc: |
      A genome id or filename. See details below. Default is hg18.

  maxZoom:
    type: int?
    inputBinding:
      prefix: --maxZoom
    doc: |
      -z, --maxZoom num       Specifies the maximum zoom level to precompute.

  windowSize:
    type: int?
    inputBinding:
      prefix: --windowSize
    doc: |
      -w, --windowSize num  The window size over which coverage is averaged. Defaults to 25 bp.

  extFactor:
    type: int?
    inputBinding:
      prefix: --extFactor
    doc: |
       -e, --extFactor num   The read or feature is extended by the specified distance
       in bp prior to counting. This option is useful for chip-seq
       and rna-seq applications. The value is generally set to the
       average fragment length of the library minus the average read length.

  preExtFactor:
    type: int?
    inputBinding:
      prefix: --preExtFactor
    doc: |
      --preExtFactor  num   The read is extended upstream from the 5' end by the specified distance.

  postExtFactor:
    type: int?
    inputBinding:
      prefix: --postExtFactor
    doc: |
      --postExtFactor num   Effectively overrides the read length, defines the downstream extent
       from the 5' end.  Intended for use with preExtFactor.

  windowFunctions:
    type: string[]?
    inputBinding:
      prefix: --windowFunctions
      itemSeparator: ','
    doc: |
      -f, --windowFunctions  list     A comma delimited list specifying window functions to use
       when reducing the data to precomputed tiles.   Possible
       values are  min, max,  mean, median, p2, p10, p90, and p98.
       The "p" values represent percentile, so p2=2nd percentile,

  strands:
    type:
    - "null"
    - type: enum
      symbols: [read, first]
    inputBinding:
      prefix: --strands
    doc: |
      --strands [arg] By default, counting is combined among both strands.
        This setting outputs the count for each strand separately.
        Legal argument values are 'read' or 'first'.
        'read' Separates count by 'read' strand, 'first' uses the first in pair strand.
        Results are saved in a separate column for .wig output, and a separate track
        for TDF output.

  bases:
    type: boolean?
    inputBinding:
      prefix: --bases
    doc: |
      --bases   Count the occurrence of each base (A,G,C,T,N). Takes no arguments.
        Results are saved in a separate column for .wig output, and a separate track for TDF output.

  query:
    type: string?
    inputBinding:
      prefix: --query
    doc: |
      --query [querystring] Only count a specific region. Query string has syntax <chr>:<start>-<end>. e.g. chr1:100-1000.
        Input file must be indexed.

  minMapQualityScore:
    type: int?
    inputBinding:
      prefix: --minMapQualityScore
    doc: |
      --minMapQuality [mqual] Set the minimum mapping quality of reads to include. Default is 0.

  includeDuplicates:
    type: boolean?
    inputBinding:
      prefix: --includeDuplicates
    doc: |
      --includeDuplicates    Include duplicate alignments in count. Default false.  If this flag is included, duplicates
        are counted. Takes no arguments

  pairs:
    type: boolean?
    inputBinding:
      prefix: --pairs
    doc: |
      --pairs  Compute coverage from paired alignments counting the entire insert as covered.  When using this option only
         reads marked "proper pairs" are used.

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.outputFileName)

baseCommand: [igvtools, count]
