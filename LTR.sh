#!/bin/bash

#help function
Help ()
{
printf "This script is used to annotate and classify LTR retrotransposons.\n\n"
printf "Usage: LTR.sh -f {filename} -db {database} -t {no. of threads}\n\n"
printf " -f FILENAME       input TE sequences in fasta format with either .fasta, .faa, .fas, .fna or .afasta extension [required].\n"
printf "\n-db DATABASE     input one of these - rexdb, rexdb-plant, rexdb-metazoa, gydb [required].\n"
printf "\n-t  THREADS      number of processors to use, number between 20 - 30 is preferable [required].\n"
}

#reads flags and assigns inputs to variables
while getopts f:db:t:h option
do
case "${option}"
in
f) Filename=${OPTARG};;
db) database=${OPTARG};;
t) threads=${OPTARG};;
h) Help
   exit;;

esac
done


#Confirm if all parameters are present
if [ $# -ne 6 ]; then
    echo "Error: must input parameters correctly"
    echo "./LTR.sh -h for more information"
fi

#use user input and strip white space from file name
file=${2}
infile=$(echo $file | tr -d ' ')

#check if file exist in path
if [ ! -f "$infile" ]; then
    echo "Error: $infile does not exist in path"
    echo "./LTR.sh -h for more information"
    exit 0
fi

#confirms that the file is in fasta format and has correct extension
ext="${infile##*.}"
case "$ext" in
"fa"|"fas"|"fasta"|"fna"|"faa"|"afasta")
    ;;
*)
    echo "Error: File must be in fasta format!!"
    echo "./LTR.sh -h for more information"
    exit 0
    ;;
esac

#confirms that the database is in the correct format
database=${4}
case "$database" in
"gydb"|"rexdb"|"rexdb-plant"|"rexdb-metazoa")
    ;;
*)
    echo "Database unknown"
    echo "./LTR.sh -h for more information"
    exit 0
    ;;
esac

#confirms that the thread is the correct length (20<thread<60)
thread=${6}
if [ "$thread" != 20 ] && [ "$thread" -le 60 ]; then
     echo "thread should be a number between 20 and 60"
      exit 0
fi

echo "All parameters met!"

#suffixerator creates an index for LTRharvest
#LTRharvest and LTR_finder detect all possible LTR-RT in genome

module load genometools/1.6.1

gt suffixerator -db $infile -indexname $infile -tis -suf -lcp -des -ssp -sds -dna
gt ltrharvest -index $infile -seqids yes -minlenltr 100 -maxlenltr 7000 -mintsd 4 -maxtsd 6 -similar 85 -vic 10 -seed 20 -motif TGCA -motifmis 1 > $infile.harvest.scn
gt ltrharvest -index $infile -seqids yes -minlenltr 100 -maxlenltr 7000 -mintsd 4 -maxtsd 6 -similar 85 -vic 10 -seed 20 > $infile.harvest.nonTGCA.scn

module load ltrfinder/1.07

ltr_finder -D 15000 -d 1000 -l 100 -L 12000 -p 20 -C -M 0.85 $infile > $infile.finder.scn

#ltr retriever is used to filter out false positive LTR-RT in the .scn files and outputs intact elements.

module load trf/4.09

./LTR_retriever -genome $infile -inharvest $infile.harvest.scn -infinder $infile.finder.scn -nonTGCA $infile.harvest.nonTGCA.scn -threads $thread -noanno

#if there are intact LTR-RT found it continues, if not it exits
if [ -s "$infile.pass.list" ]
then
    echo "LTR-RT found in Genome!!"
else
    echo "No LTR-RT found in genome!!"
    rm Tpases*
    rm alluni*
    rm $infile.*
    rm -rf LTRretriever-pre04*
    exit 0
fi

#extracts fasta sequences of the intact elements list
awk '{if ($1~/[0-9]+/) print $10"\t"$1}' $infile.pass.list >  $infile.pass.list.extract
perl call_seq_by_list.pl $infile.pass.list.extract -C $infile > $infile.fasta

#removing files
rm $infile.nmtf*
rm -rf LTRretriever-pre04*

module load python/2.7.15
module load hmmer/3.1b2
module load ncbi-blast/2.2.31

#calling TEsorter to classify the intact LTR-RT
python ~/Scripting_class/TEsorter/TEsorter.py -db $database -st nucl -p $thread $infile.fasta

#creating final output files
mv $infile.fasta.$database.cls.tsv Classified_LTRs.tsv
mv $infile.fasta.$database.dom.gff3 Classified_LTRs.gff3

#removing intermediate files
rm $infile.*
rm -rf tmp
