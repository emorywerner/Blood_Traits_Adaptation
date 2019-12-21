#!/bin/bash
#$ -cwd
#$ -q broad
#$ -N null
#$ -t 1-22
#$ -tc 22
#$ -o logs/
#$ -e logs/
#$ -l os=RedHat7,h_rt=1:00:00,h_vmem=50g
#$ -binding linear:1
#$ -pe smp 1 

chr=$SGE_TASK_ID

alpha="-1"
i="1"

plink="/broad/sankaranlab/elw/null_pheno/duplicates/new/chr${chr}.pgen"
fam="/broad/sankaranlab/elw/null_pheno/duplicates/new/chr${chr}.fam"

source /broad/software/scripts/useuse
use R-3.5

Rscript generate_null_phenos.R ${alpha} ${i} ${chr} ${plink} ${fam}


