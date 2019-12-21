#!/bin/bash
#$ -cwd
#$ -q broad
#$ -N merge
#$ -t 1-19
#$ -tc 19
#$ -o logs/
#$ -e logs/
#$ -l os=RedHat7,h_rt=1:00:00,h_vmem=25g
#$ -binding linear:1
#$ -pe smp 1


#create file with info from GWAS files and column for LD clump

phenos_list="/broad/sankaranlab/elw/blood_traits/blood_traits/phenos.txt"
length="$(wc -l $phenos | awk '{print $1}')"
phenos="$(cat $phenos_list | tail -n +2 | awk -v ln="${SGE_TASK_ID}" "NR==ln" | awk '{print $2}')"




GWAS="/broad/sankaranlab/elw/MathiesonAF/phenos/${phenos}.GWAS.txt "
LD="/broad/sankaranlab/elw/LD_clump/new/${phenos}/${phenos}.clumps"



source /broad/software/scripts/useuse
use R-3.5

Rscript mergeLDclumpsandGWAS.R ${phenos} ${GWAS} ${LD}

