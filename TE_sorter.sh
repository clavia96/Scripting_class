#!/bin/bash

module load python/2.7.15
module load hmmer/3.1b2
module load ncbi-blast/2.2.31+


python /home/olo0002/TEsorter/TEsorter.py -db gydb -st nucl -p 10 genome_pass_list.fa
