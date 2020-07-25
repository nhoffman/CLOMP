#!/usr/bin/env nextflow

//FASTA_CHANNEL = Channel.fromPath("s3://clomp-reference-data/aligner-testing/extreme_split/*")
//FASTA_CHANNEL = Channel.fromPath("s3://clomp-reference-data/aligner-testing/small_refseq/*")
//FASTA_CHANNEL = Channel.fromPath("s3://clomp-reference-data/aligner-testing/fna/*")
FASTA_CHANNEL = Channel.fromPath('${params.INPUT}/*.fna')
process build_snap_index {
 container 'quay.io/fhcrc-microbiome/snap-no-header:v1.0beta.18--0'
 publishDir '${params.OUTDIR}' , mode: 'copy'

 //for large index build
 //memory '470 GB'
 //cpus 63

 // should be sufficient for small index build 
 //memory '128 GB'
 //cpus 16
 errorStrategy 'retry'
  maxErrors 10
 input:
   file fasta_file from FASTA_CHANNEL
 output:
    file "${fasta_file}.snapindex/"
script:
 """
#!/bin/bash
set -e
echo "Workflow started"

echo "ls of directory"
ls -lahtr

echo trimming
tr ' ' \\_ < ${fasta_file} > space_removed.fasta

echo "disk use"
df -h

echo "Snap build started"
snap-aligner index space_removed.fasta ${fasta_file}.snapindex -t63 -locationSize 5

echo "Final contents of working directory:"
ls -lahtr
echo Done
 """
}
