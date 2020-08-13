import sys
import uuid
import ast 
import subprocess
import pysam
import glob
import argparse 
import os
import operator
from collections import Counter
from ete3 import NCBITaxa
import timeit
from collections import defaultdict
ncbi = NCBITaxa(dbfile = 'taxa.sqlite')

read_to_taxids_map = {}
reads_seq_map = {}
#z = open("${base}_unassigned.txt", 'w')


base = sys.argv[1]
fasta_file = sys.argv[2]
blast_db = sys.argv[3]
cpus = sys.argv[4]
eval_cutoff = sys.argv[5]


#fasta_file = '/Users/gerbix/Documents/vikas/scratch/test.fasta'
#base = 'test'
subprocess.call('blastn -db ' + blast_db +  ' -task blastn -query ' + base + '_unassigned.txt -num_threads ' +  cpus + ' -evalue ' + eval_cutoff + ' -outfmt "6 qseqid" -max_target_seqs 1 -max_hsps 1 > blast_check.txt', shell = True)

#for line in open('blast_check.txt'): 

#fasta = open("${base}_unassigned.txt")
fasta = {}
with open(fasta_file) as file_one:
    for line in file_one:
        line = line.strip()
        if not line:
            continue
        if line.startswith(">"):
            active_sequence_name = line[1:]
            if active_sequence_name not in fasta:
                fasta[active_sequence_name] = []
            continue
        sequence = line
        fasta[active_sequence_name].append(sequence)




reassigned = {}
for line in open(fasta_file):
    current_line = line.split()
    reassigned[current_line[0]] = str(current_line[1])

unique_taxids = set(reassigned.values())
print(unique_taxids)

taxid_counts = {} 
for taxid in unique_taxids: 
    count = sum(value == taxid for value in reassigned.values())
    taxid_counts[taxid] = count


temp_filename = base + 'unassigned_temp_kraken.tsv'

l = open(temp_filename, 'w')

still_unassigned_count = len(fasta) - len(reassigned)

l.write('0\t' + str(still_unassigned_count))
# write the rest of the taxids to the file
for key in taxid_counts.keys():
    print(key)
    l.write('\n' + str(key) + '\t' + str(taxid_counts[key]))

# generate pavian report
final_filename = base + 'unassigned_report.tsv'
kraken_report_cmd = '/usr/local/miniconda/bin/krakenuniq-report --db kraken_db --taxon-counts ' + temp_filename + ' > ' + final_filename

subprocess.call(kraken_report_cmd, shell = True)
