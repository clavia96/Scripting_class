#!/bin/bash

#help function
Help ()
{
printf "Syntax: filetest filename\n"
printf "Use to create table containing LTR retrotransposons, \nas well as thier clade and protein domains."
printf "\nMust input filetest: fasta file and filename: a gydb or redexb database."
printf "\nDatabase with greater than 20 threads is preferable.\n"
}

#creating -h option
while getopts ":h" option; do
    case $option in
        h)
            Help
            exit;;
    esac
done

#use user input and strip white space
#changed number of parameters to 2
if [[ $# -ne 2 ]]; then
    echo "Error: must input parameters filetest and filename"
    echo "./Script.bash -h for more information"
fi

file=${1}

infile=$(echo $file | tr -d ' ')

#check if file exist
if [ ! -f "$infile" ]; then
    echo "Error: $infile does not exist in path"
    echo "./Script.bash -h for more information"
    exit 0
fi

#confirm file is in fasta format using extension
ext="${infile##*.}"
#echo $ext
case "$ext" in
"fa"|"fas"|"fasta"|"fna"|"faa"|"afasta")
    ;;
*)
    echo "Error: File must be in fasta format!!"
    echo "./Script.bash -h for more information"
    exit 0
    ;;
esac

module load genometools/1.6.1


gt suffixerator -db $infile -indexname $infile -tis -suf -lcp -des -ssp -sds -dna
gt ltrharvest -index $infile -seqids yes -minlenltr 100 -maxlenltr 7000 -mintsd 4 -maxtsd 6 -similar 85 -vic 10 -seed 20 -motif TGCA -motifmis 1 > $infile.harvest.scn
gt ltrharvest -index $infile -seqids yes -minlenltr 100 -maxlenltr 7000 -mintsd 4 -maxtsd 6 -similar 85 -vic 10 -seed 20 > $infile.harvest.nonTGCA.scn

module load anaconda/3-2020.02
ltr_finder -D 15000 -d 1000 -l 100 -L 7000 -p 20 -C -M 0.85 $infile > $infile.finder.scn

module load perl/5.24.0
module load anaconda/2-5.0.1
./LTR_retriever -genome $infile -infinder $infile.finder.scn -inharvest $infile.harvest.scn -nonTGCA $infile.harvest.nonTGCA.scn -threads 10
awk '{if ($1~/[0-9]+/) print $10"\t"$1}' $infile.pass.list >  $infile.pass.list.extract
perl call_seq_by_list.pl $infile.pass.list.extract -C $infile > $infile.fasta

