AWS_PROFILE=covid \
nextflow run /Users/gerbix/Documents/vikas/CLOMP/CLOMP/main.nf \
--SNAP_INDEXES "/Users/gerbix/Documents/vikas/CLOMP/CLOMP_validation/salipante_files/salipante_S_aureus/debugging/saureusdb/Homo_sapiens.GRCh38.dna.chromosome.1.fna.snapindex,/Users/gerbix/Documents/vikas/CLOMP/CLOMP_validation/salipante_files/salipante_S_aureus/debugging/saureusdb/SA_snap_index" \
--INPUT_SUFFIX=".fastq.gz" \
--SNAP_OPTIONS "-mrl 65 -d 9 -h 30000 -om 1 -omax 20" \
--TRIMMOMATIC_OPTIONS  ":2:30:10 SLIDINGWINDOW:4:20" \
--BWT_DB_LOCATION "s3://clomp-reference-data/tool_specific_data/CLOMP/hg38/" \
--TRIMMOMATIC_ADAPTER_PATH s3://clomp-reference-data/tool_specific_data/CLOMP/adapters.fa \
--TRIMMOMATIC_JAR_PATH "s3://clomp-reference-data/tool_specific_data/CLOMP/trimmomatic-0.38.jar" \
--KRAKEN_DB_PATH s3://clomp-reference-data/tool_specific_data/CLOMP/kraken_db/ \
--INPUT_FOLDER "/Users/gerbix/Documents/vikas/CLOMP/CLOMP_validation/salipante_files/salipante_S_aureus/debugging/saureusdb/" \
--OUTDIR "/Users/gerbix/Documents/vikas/CLOMP/CLOMP_validation/salipante_files/salipante_S_aureus/debugging/output/" \
-with-docker ubuntu:18.04 \
-profile local \
-with-trace \
-with-report \
-resume
