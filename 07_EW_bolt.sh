#$ -cwd
#$ -q broad
#$ -N bolt
#$ -t 1-22
#$ -tc 22
#$ -o logs/
#$ -e logs/
#$ -l os=RedHat7,h_rt=100:00:00,h_vmem=30g
#$ -binding linear:3
#$ -pe smp 3

chr=$SGE_TASK_ID
cores=3


#directories
bolt="/broad/sankaranlab/tools/BOLT-LMM_v2.3.2/bolt"
indir="/broad/sankaranlab/ebao/ukbb_500k/BOLT/input"
bgen_dir="/broad/ukbb/imputed_v3"
outdir="/broad/sankaranlab/elw/null_pheno/duplicates/new/bolt"
samfile="/psych/genetics_data/projects/ukbb_31063/phenotypes/ukb31063.sample"


${bolt} \
--bfile=/broad/sankaranlab/elw/bolt_plink/ukb_maf_hwe_ldpruned_merged \
--phenoFile=/broad/sankaranlab/elw/null_pheno/duplicates/december/freqs/sim/sim_p_1.tsv \
--phenoCol=p \
--covarFile=${indir}/ukbb_covariates.txt \
--covarCol=sex \
--qCovarCol=age \
--LDscoresFile=/broad/sankaranlab/tools/BOLT-LMM_v2.3.2/tables/LDSCORE.1000G_EUR.tab.gz \
--lmmForceNonInf \
--numThreads=${cores} \
--statsFile=${outdir}/chr${chr}.txt 


#december 17: remove chr23 
awk '{if ($2 != 23) print $0}' chr1.txt > /broad/sankaranlab/elw/null_pheno/duplicates/december/bolt/bolt_combined.txt
#december 14
#--phenoFile=/broad/sankaranlab/elw/null_pheno/duplicates/december/freqs/sim/sim_p_combined2.tsv
#error about duplicated FID

#dont have permission to open ukbb folder in broad
#--bgenFile=${bgen_dir}/ukb_imp_chr${chr}_v3.bgen \
#--bgenMinMAF=0.0001 \
#--bgenMinINFO=0.6 \
#--sampleFile=$samfile \
#--statsFileBgenSnps=${outdir}/chr${chr}.2

#--fam=/broad/sankaranlab/elw/null_pheno/duplicates/chr${chr} \
#--bim=/broad/sankaranlab/elw/null_pheno/duplicates/chr${chr}.bim \

#--bgenFile=$bgen_dir/ukb_imp_chr${chr}_v3.bgen \
#--bgenMinMAF=0.0001 \
#--bgenMinINFO=0.6 \
#--sampleFile=$samfile \

#--statsFileBgenSnps=${outfile}.2