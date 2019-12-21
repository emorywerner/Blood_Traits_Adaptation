#$ -cwd
#$ -q broad
#$ -N plink
#$ -t 1-22
#$ -tc 22
#$ -o logs/
#$ -e logs/
#$ -l os=RedHat7,h_rt=24:00:00,h_vmem=30g
#$ -binding linear:1
#$ -pe smp 1

#use plink to create frequency files 

chr=$SGE_TASK_ID

plink="/broad/sankaranlab/tools/plink2"
plinkfile="/broad/sankaranlab/elw/null_pheno/duplicates/december/chr${chr}"
outdir="/broad/sankaranlab/elw/null_pheno/duplicates/december/freqs/chr${chr}"



$plink --bpfile ${plinkfile} \
--freq \
--out $outdir
