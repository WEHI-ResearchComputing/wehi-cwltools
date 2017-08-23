#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
- $import: samtools-env.yml
- class: InlineJavascriptRequirement

inputs:
  inputFile:
    type: File
    inputBinding:
      position: 99
    doc: |
      The input data file must be position sorted and compressed by bgzip which has a gzip(1) like interface.

  d:
    type: boolean?
    inputBinding:
      prefix: -d

  B:
    type: boolean?
    inputBinding:
      prefix: -B

  h:
    type: boolean?
    inputBinding:
      prefix: -h

  b:
    type: string?
    inputBinding:
      prefix: -b

outputs:
  bgzip:
    type: File
    outputBinding:
      glob: $(inputs.inputFile.basename).gz

#
# see https://github.com/common-workflow-language/common-workflow-language/issues/226
# for an explanation of why '-c' is required.
#
baseCommand: [bgzip, '-c']

stdout: $(inputs.inputFile.basename).gz