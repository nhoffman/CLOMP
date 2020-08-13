AWS_PROFILE=covid \
nextflow run /Users/gerbix/Documents/vikas/CLOMP/CLOMP/main.nf \
--SNAP_INDEXES "/Users/gerbix/Documents/vikas/CLOMP/CLOMP_validation/histo_debugging/histo_gcf_snap_db/" \
--INPUT_SUFFIX=".fastq.gz" \
--SNAP_OPTIONS "-mrl 65 -d 9 -h 30000 -om 1 -omax 20" \
--TRIMMOMATIC_OPTIONS  ":2:30:10 HEADCROP:10 SLIDINGWINDOW:4:20 CROP:65 MINLEN:65" \
--BWT_DB_LOCATION "s3://clomp-reference-data/tool_specific_data/CLOMP/hg38/" \
--TRIMMOMATIC_ADAPTER_PATH "s3://clomp-reference-data/tool_specific_data/CLOMP/adapters.fa" \
--TRIMMOMATIC_JAR_PATH "s3://clomp-reference-data/tool_specific_data/CLOMP/trimmomatic-0.38.jar" \
--KRAKEN_DB_PATH "s3://clomp-reference-data/tool_specific_data/CLOMP/kraken_db/" \
--INPUT_FOLDER "/Users/gerbix/Documents/vikas/CLOMP/CLOMP_validation/eukaryotic_pathogens/fungi_fake/wgsim/novaseq_model_attempt/subsampled/" \
--OUTDIR "/Users/gerbix/Documents/vikas/CLOMP/CLOMP_validation/eukaryotic_pathogens/fungi_fake/wgsim/local_clomp_output/" \
--BLAST_CHECK_DB "/Users/gerbix/Documents/vikas/scratch/blast_db/" \
--BLAST_CHECK "True" \
-with-docker ubuntu:18.04 \
-profile local \
-with-trace \
-with-report \
-resume
