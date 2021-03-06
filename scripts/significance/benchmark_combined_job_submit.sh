#!/bin/bash

# $1 sRNA
# $2 target RNA
# $3 start pos
# $4 stop pos

for i in /home/suu13/bin/*query.sh; do ln -s $i; done
ln -s /home/suu13/progs/fasta-36.3.6d/bin/ssearch36
ln -s /home/suu13/progs/fasta-36.3.6d/data/rna.mat




qsub IntaRNA_query.sh $1 $2
#qsub RNAcofold_query.sh $1 $2
qsub RNAhybrid_query.sh $1 $2
qsub RIsearch_query.sh $1 $2
qsub RNAduplex_query.sh $1 $2
qsub RNAplex_query.sh $1 $2
qsub -pe multi_thread 10 RNAup_query.sh $1 $2 $3 $4 10
#qsub -pe multi_thread 10 pairfold_query.sh $1 $2 10
qsub -pe multi_thread 2 DuplexFold_query.sh $1 $2
qsub -pe multi_thread 2 AccessFold_query.sh $1 $2
#qsub -pe multi_thread 20 bifold_query.sh $1 $2 20
./ssearch36_query.sh $1 $2

