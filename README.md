## Table of Contents

   * [Introduction](#introduction)
   * [Installation](#installation)
   * [Usage](#usage)
   * [Outputs](#outputs)
   * [Test-File](#Test-file)
   * [Citations](#citations)
   

### Introduction ###

This is a combination of programs used to annotate and classify LTR retrotransposons in a genome.

Created by Oluchi Oyekwe, Beatrice Severance, and Jennifer Jones
for Scripting for Biologists Spring 2020

### Installation ###

Dependencies: ncbi-blast, hmmer, python2.7, parallel python, biopython, genometools/1.6.1, repeatmasker, CDhit, tandem repeat finder and perl/5.24.0

All Dependencies required for this script has been called in the script for hopper users, hence calling them seperately is not necessary. 
However, for ASC users, this dependencies will need to be manually edited in the LTR.sh script.

To edit the dependencies modules:
+ Edit the paths file to the corresponding file location on ASC.
+ Replace the Modules called in the script with the corresponding module name on ASC.

ASC dependencies are similar to HOPPER dependencies. However, ncbi-blast will need to be printed as blast+ in this case, and anaconda environments will need to be loaded. These environments are “anaconda/3-2020.02” and “anaconda/2-5.0.1”, and should include the other dependencies necessary for running the script.

### Usage ### 

```
$ bash LTR.sh -h

This script is used to annotate and classify LTR retrotransposons.

Usage: LTR.bash -f {filename} -db {database} -t {no. of threads}

 -f FILENAME    input TE sequences in fasta format with either .fasta, .faa, .fas, .fna or .afasta extension [required].

-db DATABASE    input one of these - rexdb, rexdb-plant, rexdb-metazoa, gydb [required].

-t THREADS      number of processors to use, number between 20 - 30 is preferable [required].

-h              show this help message and exit


All parameters must be correctly placed for script to work!!

To submit this script on a queue, you can edit the RunLTR.sh script and submit to the queue.

```

### Output ###

```
Classified_LTRs.tsv                      LTRs classification
    Column 1: raw id
    Column 2: Order, i.e. LTR
    Column 3: Superfamily, e.g. Copia
    Column 4: Clade, e.g. SIRE
    Column 5: Complete, "yes" means one LTR Copia/Gypsy element with full GAG-POL domains.
    Column 6: Strand, + or - or ?
    Column 7: Domains, e.g. GAG|SIRE PROT|SIRE INT|SIRE RT|SIRE RH|SIRE; `none` for pass-2 classifications

Classified_LTRs.gff3                    LTRs domain annotation in 'gff3' format

```
### Test-Files ###

To test this script, user can use the test.nonLTR.fasta or the Arabidopsis genome file.

The test.nonLTR.fasta is a genome without LTR-RT while Arabidopsis thaliana genome contains LTR-RT


### Citations ###

This Script is a combination of the following programs

+    LTRharvest            (https://github.com/genometools/genometools)
+    LTR_finder_parallel   (https://github.com/oushujun/LTR_FINDER_parallel)
+    LTR_retriever         (https://github.com/oushujun/LTR_retriever)
+    TEsorter              (https://github.com/zhangrengang/TEsorter)
