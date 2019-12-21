#!/bin/bash
#$ -cwd
#$ -q broad
#$ -N tabs
#$ -t 1
#$ -tc 1
#$ -o logs/
#$ -e logs/
#$ -l os=RedHat7,h_rt=1:00:00,h_vmem=25g
#$ -binding linear:1
#$ -pe smp 1

#determine which LD clump each variant present in the ancient data set falls into

phenos_list="/broad/sankaranlab/elw/blood_traits/blood_traits/phenos.txt"
length="$(wc -l $phenos | awk '{print $1}')"
phenos="$(cat $phenos_list | tail -n +2 | awk -v ln="${SGE_TASK_ID}" "NR==ln" | awk '{print $2}')"



LD="/broad/sankaranlab/elw/LD_clump/new/${phenos}/${phenos}.combined"

Ancient="/broad/sankaranlab/elw/MathiesonAF/phenos/${phenos}.GWAS.txt"

outdir="/broad/sankaranlab/elw/LD_clump/new/${phenos}"

for line in `rev $Ancient | cut -f1 | rev`; do
    echo $line $(grep -n -m1 $line $LD | cut -f1 -d":")
done > ${outdir}/${phenos}.clumps



