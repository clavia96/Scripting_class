#!/bin/bash

module load genometools
module load anaconda/3-2020.02

#use user input and strip white space
if [[ $# -ne 1 ]]; then
 echo "Usage: filetest filename"
        exit 1
fi

file=${1}

infile=$(echo $file | tr -d ' ')

#check if file exist
if [ ! -f "$infile" ]; then
    echo "Error: $infile does not exist in path"
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
    exit 0
    ;;
esac

#gt suffixerator -db $infile -indexname $infile -tis -suf -lcp -des -ssp -sds -dna
#gt ltrharvest -index $infile -seqids yes -minlenltr 100 -maxlenltr 7000 -mintsd 4 -maxtsd 6 -similar 85 -vic 10 -seed 20 -motif TGCA -motifmis 1 > $infile.harvest.scn
#gt ltrharvest -index $infile -seqids yes -minlenltr 100 -maxlenltr 7000 -mintsd 4 -maxtsd 6 -similar 85 -vic 10 -seed 20 > $infile.harvest.nonTGCA.scn

#ltr_finder -D 15000 -d 1000 -l 100 -L 7000 -p 20 -C -M 0.85 $infile > $infile.finder.scn
