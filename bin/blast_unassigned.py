# Python script to run blast on unassigned reads. 
# Takes only the top hit with evalue < 1e-4 and writes into a pavian report
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

read_to_taxids_map = {}
reads_seq_map = {}


#basename
base = sys.argv[1]
#unassigned reads fasta file
fasta_file = sys.argv[2]
#blast db location
blast_db = sys.argv[3]
#threads for blast
cpus = sys.argv[4]
#blast evalue cutoff 
eval_cutoff = sys.argv[5]

filename = base + '_unassigned.txt'

# If unassigned file is empty make a blank one so the lack of output doesn't crash the script
if os.stat(filename).st_size == 0: 
    print("file is empty", flush = True)
    subprocess.call('touch ' +  base + '_unassigned_report.tsv', shell = True)
else: 
    print("Unassigned file not empty. Starting BLAST", flush = True)
    # Blast command taken from python CLOMP 
    subprocess.call('blastn -db ' + blast_db +  '/nt -task blastn -query ' + base + '_unassigned.txt -num_threads ' +  cpus + ' -evalue ' + eval_cutoff + ' -outfmt "6 qseqid staxids  bitscore sacc evalue " -max_target_seqs 1 -max_hsps 1 > blast_check.txt', shell = True)
    print("BLAST finished", flush = True)
    #logging ls
    subprocess.call('ls -lah', shell = True)

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



# Match read back to taxid from BLAST
    reassigned = {}
    for line in open('blast_check.txt'):
        current_line = line.split()
        reassigned[current_line[0]] = str(current_line[1])

    unique_taxids = set(reassigned.values())

# Sum taxids for temp kraken report
    taxid_counts = {} 
    for taxid in unique_taxids: 
        count = sum(value == taxid for value in reassigned.values())
        taxid_counts[taxid] = count


    temp_filename = 'unassigned_temp_kraken.tsv'

    l = open(temp_filename, 'w')

    still_unassigned_count = len(fasta) - len(reassigned)

    l.write('0\t' + str(still_unassigned_count))

    # write the rest of the taxids to the file
    for key in taxid_counts.keys():
        l.write('\n' + str(key) + '\t' + str(taxid_counts[key]))
# for some reason report generation fails from python subprocess call so I'm doing it in the nf script itself