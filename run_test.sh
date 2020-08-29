#run_test

nextflow run main.nf \
-profile testing \
--INPUT_FOLDER test_data/ \
--INPUT_SUFFIX .fastq.gz \
--ENTREZ_EMAIL vpeddu@uw.edu \
--OUTDIR test_data/out/ \
-work-dir test_data/work/ \
--SNAP_INDEXES "test_data/test_db_1/,test_data/test_db_2/,test_data/test_db_3/" \
--TRIMMOMATIC_OPTIONS ":2:30:10 SLIDINGWINDOW:4:20" \
--TRIMMOMATIC_JAR_PATH test_data/trimmomatic-0.38.jar \
-with-docker ubuntu:18.04 \
--KRAKEN_DB_PATH test_data/kraken_db/ \
--BWT_DB_LOCATION test_data/bt2/ \
--TRIMMOMATIC_ADAPTER_PATH test_data/adapters.fa \
--BWT_DB_PREFIX human_ref \
--TAXDUMP_NODES "/Users/gerbix/Documents/vikas/scratch/update_actions/nodes.dmp" \
--TAXDUMP_MERGED "/Users/gerbix/Documents/vikas/scratch/update_actions/merged.dmp" \
--TAXONOMY_DATABASE "/Users/gerbix/.etetoolkit/taxa.sqlite" \
--H_TAXID "0" \
-resume