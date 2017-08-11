#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

baseCommand: [awk]

inputs:
  infile:
    type: File
    streamable: true
    inputBinding:
      position: 2

  program:
    type: string
    inputBinding:
      position: 1

  outputFileName:
    type: string

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.outputFileName)

stdout: $(inputs.outputFileName)