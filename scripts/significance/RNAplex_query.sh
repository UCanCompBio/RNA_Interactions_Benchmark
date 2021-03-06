#!/bin/bash

#$ -N RNAplex
#$ -o /home/suu13/job_logs/
#$ -e /home/suu13/job_logs/
#$ -cwd
#$ -S /bin/bash
#$ -l mf=50G

# $1 sRNA file
# $2 Target file





program="RNAplex"


esl-shuffle -N 200 -d --seed 255 $2 > $1.$2.$program.200Shuffled.fasta

cat $2 $1.$2.$program.200Shuffled.fasta > $1.$2.$program.Native.200Shuffled.fasta


sRNA=$(grep -v ">" $1 | awk '{print length}')
target=$(grep -v ">" $2 | awk '{print length}')

if [ $sRNA -le $target  ]; then u=$sRNA; else u=$target; fi
if [ $u -gt 100  ]; then u=100; fi




if [ ! -n "$JOB_ID" ]; 

then
FASTA2ID_Fix.py -f $1 -v | sponge $JOB_ID.$1; #convert vienna just in case
FASTA2ID_Fix.py -f $1.$2.$program.Native.200Shuffled.fasta -v | sponge $JOB_ID.$2.Native.200Shuffled.fasta; #convert vienna

/home/suu13/progs/ViennaRNA-2.1.9/Progs/RNAplfold -W $u -u $u -O --plex_output < $JOB_ID.$1;
/home/suu13/progs/ViennaRNA-2.1.9/Progs/RNAplfold -W $u -u $u -O --plex_output < $JOB_ID.$2.Native.200Shuffled.fasta;
/home/suu13/progs/ViennaRNA-2.1.9/Progs/RNAplex -l $u -q $JOB_ID.$1 -t $JOB_ID.$2.Native.200Shuffled.fasta -a ./ > $1.$2.RNAplex.result.txt;


else
FASTA2ID_Fix.py -f $1 -v | sponge $1; #convert vienna just in case
FASTA2ID_Fix.py -f $1.$2.$program.Native.200Shuffled.fasta -v | sponge $1.$2.$program.Native.200Shuffled.fasta; #convert vienna
/home/suu13/progs/ViennaRNA-2.1.9/Progs/RNAplfold -W $u -u $u -O --plex_output < $1;
/home/suu13/progs/ViennaRNA-2.1.9/Progs/RNAplfold -W $u -u $u -O --plex_output < $1.$2.$program.Native.200Shuffled.fasta;
/home/suu13/progs/ViennaRNA-2.1.9/Progs/RNAplex -l $u -q $1 -t $1.$2.$program.Native.200Shuffled.fasta -a ./ > $1.$2.RNAplex.result.txt;

fi;




gawk '{match($0,/ \((.*) =/,m); if(NR%3 ==0) printf m[1]"\n"; else printf $1"\t"}' $1.$2.RNAplex.result.txt | awk '{gsub(/>/,"",$0); print $0}' > $1.$2.RNAplex.result.csv;




