#!/bin/bash

#$ -N RIsearch
#$ -o /home/suu13/job_logs/
#$ -e /home/suu13/job_logs/
#$ -cwd
#$ -S /bin/bash

# $1 sRNA file
# $2 Target file


program="RIsearch"


esl-shuffle -N 200 -d --seed 255 $2 > $1.$2.$program.200Shuffled.fasta

cat $2 $1.$2.$program.200Shuffled.fasta > $1.$2.$program.Native.200Shuffled.fasta


RIsearch -q $1 -t $1.$2.$program.Native.200Shuffled.fasta -p2 -d 30 > $1.$2.RIsearch.result.txt;

cat $1.$2.RIsearch.result.txt | awk '{print $1"\t"$4"\t"$8}' > $1.$2.RIsearch.result.csv;





