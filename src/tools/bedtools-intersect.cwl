#!/usr/bin/env cwl-runner

$namespaces:
  dct: http://purl.org/dc/terms/
  foaf: http://xmlns.com/foaf/0.1/
  doap: http://usefulinc.com/ns/doap#
  adms: http://www.w3.org/ns/adms#
  dcat: http://www.w3.org/ns/dcat#
  edam: http://edamontology.org/

$schemas:
- http://dublincore.org/2012/06/14/dcterms.rdf
- http://xmlns.com/foaf/spec/20140114.rdf
- http://usefulinc.com/ns/doap#
- http://www.w3.org/ns/adms#
- http://www.w3.org/ns/dcat.rdf
- http://edamontology.org/EDAM.owl

cwlVersion: v1.0
class: CommandLineTool

adms:includedAsset:
  doap:name: bedtools
  doap:description: |
    A software suite for the comparison, manipulation and annotation of genomic features in browser extensible data (BED) and general feature format (GFF) format.
    BEDTools also supports the comparison of sequence alignments in BAM format to both BED and GFF features.
    The tools are extremely efficient and allow the user to compare large datasets (e.g. next-generation sequencing data) with both public and custom genome annotation tracks.
    BEDTools can be combined with one another as well as with standard UNIX commands, thus facilitating routine genomics tasks as well as pipelines that can quickly answer intricate questions of large genomic datasets.
  doap:homepage: http://bedtools.readthedocs.org
  doap:repository:
  - class: doap:GitRepository
    doap:location: https://github.com/arq5x/bedtools2
  doap:release:
  - class: doap:Version
    doap:revision: 2.25.0
  doap:license: GPLv2
  doap:category: commandline tool
  doap:programming-language: C++
  foaf:publications:
  - id: urn:pmid:20110278
    foaf:title: 'Aaron R. Quinlan, Ira M. Hall (2010) BEDTools: a flexible suite of
      utilities for comparing genomic features. Bioinformatics, 26(6) 841-842, http://dx.doi.org/10.1093/bioinformatics/btq033'
    foaf:homepage: http://bioinformatics.oxfordjournals.org/content/26/6/841
  doap:maintainer:
  - class: foaf:Person
    foaf:name: Aaron R. Quinlan
    foaf:mbox: aaronquinlan at gmail.com
    dct:isPartOf:
    - class: foaf:Organization
      foaf:name: Department of Biochemistry and Molecular Genetics, University of
        Virginia School of Medicine
    - class: foaf:Organization
      foaf:name: Center for Public Health Genomics, University of Virginia, Charlottesville,
        VA 22908, USA
doap:name: bedtools-genomecov.cwl
dcat:downloadURL: https://github.com/common-workflow-language/workflows/blob/master/tools/bedtools-genomecov.cwl
doap:maintainer:
- class: foaf:Organization
  foaf:name: Barski Lab, Cincinnati Children's Hospital Medical Center
  foaf:member:
  - class: foaf:Person
    id: http://orcid.org/0000-0001-9102-5681
    foaf:openid: http://orcid.org/0000-0001-9102-5681
    foaf:name: Andrey Kartashov
    foaf:mbox: mailto:Andrey.Kartashov@cchmc.org
requirements:
- $import: bedtools-env.yml
- class: InlineJavascriptRequirement

inputs:
  intersectout: string

  inputA:
    type: File
    inputBinding:
       prefix: -a
    doc: |
      -a <bed/gff/vcf/bam>

  inputB:
    type:
    - File
    - type: array
      items: File
    inputBinding:
       prefix: -b
    doc: |
      -b <bed/gff/vcf/bam> Note: -b may be followed with multiple databases and/or wildcard (*) character(s).

  writeA:
    type: boolean?
    inputBinding:
      prefix: -writeA
    doc: |
      -wa Write the original entry in A for each overlap.

  writeB:
    type: boolean?
    inputBinding:
      prefix: -wb
    doc: |
        -wb Write the original entry in B for each overlap. - Useful for knowing _what_ A overlaps. Restricted by -f and -r.

  leftOuterJoin:
    type: boolean?
    inputBinding:
      prefix: -loj
    doc: |
      -loj  Perform a "left outer join". That is, for each feature in A report each overlap with B.  If no overlaps are found,
      report a NULL feature for B.

  writeOriginal:
    type: boolean?
    inputBinding:
      prefix: -wo
    doc: |
      -wo Write the original A and B entries plus the number of base pairs of overlap between the two features.
      - Overlaps restricted by -f and -r. Only A features with overlap are reported.

  writeOriginalAndBasePairs:
    type: boolean?
    inputBinding:
      prefix: -woa
    doc: |
      -wao  Write the original A and B entries plus the number of base pairs of overlap between the two features.
      - Overlapping features restricted by -f and -r. However, A features w/o overlap are also reported
      with a NULL B feature and overlap = 0.

  writeAOnce:
    type: boolean?
    inputBinding:
      prefix: -u
    doc: |
      -u  Write the original A entry _once_ if _any_ overlaps found in B.
      - In other words, just report the fact >=1 hit was found.
      - Overlaps restricted by -f and -r.

  reportOverlaps:
    type: boolean?
    inputBinding:
      prefix: -c
    doc: |
      -c  For each entry in A, report the number of overlaps with B.
      - Reports 0 for A entries that have no overlap with B.
      - Overlaps restricted by -f and -r.

  reportNoOverlaps:
    type: boolean?
    inputBinding:
      prefix: -v
    doc: |
      -v  Only report those entries in A that have _no overlaps_ with B.
      - Similar to "grep -v" (an homage).

  ubam:
    type: boolean?
    inputBinding:
      prefix: -ubam
    doc: |
      -ubam Write uncompressed BAM output. Default writes compressed BAM.

  sameStrandedness:
    type: boolean?
    inputBinding:
      prefix: -s
    doc: |
      -s  Require same strandedness.  That is, only report hits in B
      that overlap A on the _same_ strand.
      - By default, overlaps are reported without respect to strand.

  differentStrandedness:
    type: boolean?
    inputBinding:
      prefix: -S
    doc: |
      -S  Require different strandedness.  That is, only report hits in B
      that overlap A on the _opposite_ strand.
      - By default, overlaps are reported without respect to strand.

  minimumOverlapA:
    type: float?
    inputBinding:
      prefix: -f
    doc: |
      -f  Minimum overlap required as a fraction of A.
      - Default is 1E-9 (i.e., 1bp).
      - FLOAT (e.g. 0.50)

  minimumOverlapB:
    type: float?
    inputBinding:
      prefix: -F
    doc: |
      -F  Minimum overlap required as a fraction of B.
      - Default is 1E-9 (i.e., 1bp).
      - FLOAT (e.g. 0.50)

  requireReciprocal:
    type: boolean?
    inputBinding:
      prefix: -r
    doc: |
      -r  Require that the fraction overlap be reciprocal for A AND B.
      - In other words, if -f is 0.90 and -r is used, this requires
      that B overlap 90% of A and A _also_ overlaps 90% of B.

  requireMinimumFraction:
    type: boolean?
    inputBinding:
      prefix: -e
    doc: |
      -e  Require that the minimum fraction be satisfied for A OR B.
      - In other words, if -e is used with -f 0.90 and -F 0.10 this requires
      that either 90% of A is covered OR 10% of  B is covered.
      Without -e, both fractions would have to be satisfied.

  split:
    type: boolean?
    inputBinding:
      prefix: -split
    doc: |
      -split  Treat "split" BAM or BED12 entries as distinct BED intervals.

  genomeFile:
    type: File?
    inputBinding:
      prefix: -g
    doc: |
      -g  Provide a genome file to enforce consistent chromosome sort order
      across input files. Only applies when used with -sorted option.

  nonameCheck:
    type: boolean?
    inputBinding:
      prefix: -nonamecheck
    doc: |
      -nonamecheck  For sorted data, don't throw an error if the file has different naming conventions
      for the same chromosome. ex. "chr1" vs "chr01".

  sorted:
    type: boolean?
    inputBinding:
      prefix: -sorted
    doc: |
      -sorted Use the "chromsweep" algorithm for sorted (-k1,1 -k2,2n) input.

  name:
    type:
    - "null"
    - string
    - type: array
      items: string
    inputBinding:
      prefix: -names
    doc: |
      -names  When using multiple databases, provide an alias for each that
      will appear instead of a fileId when also printing the DB record.

  filenames:
    type: boolean?
    inputBinding:
      prefix: -filenames
    doc: |
      -filenames  When using multiple databases, show each complete filename
      instead of a fileId when also printing the DB record.

  sortout:
    type: boolean?
    inputBinding:
      prefix: -sortout
    doc: |
      -sortout  When using multiple databases, sort the output DB hits
      for each record.

  bed:
    type: boolean?
    inputBinding:
      prefix: -bed
    doc: |
      -bed  If using BAM input, write output as BED.

  header:
    type: boolean?
    inputBinding:
      prefix: -header
    doc: |
      -header Print the header from the A file prior to results.

  nobuf:
    type: boolean?
    inputBinding:
      prefix: -nobuf
    doc: |
      -nobuf  Disable buffered output. Using this option will cause each line
      of output to be printed as it is generated, rather than saved
      in a buffer. This will make printing large output files
      noticeably slower, but can be useful in conjunction with
      other software tools and scripts that need to process one
      line of bedtools output at a time.

  iobuf:
    type: string?
    inputBinding:
      prefix: -iobuf
    doc: |
      -iobuf  Specify amount of memory to use for input buffer.
      Takes an integer argument. Optional suffixes K/M/G supported.
      Note: currently has no effect with compressed files.

outputs:
  intersect:
    type: File
    streamable: true
    outputBinding:
      glob: $(inputs.intersectout)

    doc: The file containing the intersect data

stdout: $(inputs.intersectout)

baseCommand: [bedtools, intersect]
