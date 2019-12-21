#$ -cwd
#$ -q broad
#$ -N score
#$ -t 1-22
#$ -tc 22
#$ -o logs/
#$ -e logs/
#$ -l os=RedHat7,h_rt=24:00:00,h_vmem=30g
#$ -binding linear:1
#$ -pe smp 1

chr=$SGE_TASK_ID

plink="/broad/sankaranlab/tools/plink2"
#plink_file="/broad/sankaranlab/elw/null_pheno/duplicate/chr1"
#outdir="/broad/sankaranlab/elw/null_pheno/duplicates"
plink_file="/broad/sankaranlab_archive/ebao/PRS_all/hinds_finngen_PRS_all.chr${chr}"
outdir="/broad/sankaranlab/elw/null_pheno/duplicates/december"


$plink --bpfile ${plink_file} \
--rm-dup exclude-all \
--make-just-bim \
--make-just-fam \
--out ${outdir}/chr${chr} 

