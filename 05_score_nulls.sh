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
plink_file="/broad/sankaranlab/elw/null_pheno/duplicates/december/chr${chr}"
score_file="/broad/sankaranlab/elw/null_pheno/duplicates/december/freqs/sim/sim_beta${chr}.tsv"

$plink --bpfile ${plink_file} \
--score  ${score_file} \
--memory 671088640 \
--out /broad/sankaranlab/elw/null_pheno/duplicates/december/freqs/sim/simu_g${chr}

#/broad/sankaranlab/tools/plink2 --bpfile /broad/sankaranlab_archive/ebao/PRS_all/hinds_finngen_PRS_all.chr21 --score  /broad/sankaranlab/elw/null_pheno/freqs/sim_beta1.tsv --out /broad/sankaranlab/elw/null_pheno/freqs/simu_g1

