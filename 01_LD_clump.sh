#$ -cwd
#$ -q broad
#$ -N LDclump
#$ -t 1-22
#$ -tc 22
#$ -o logs/
#$ -e logs/
#$ -l os=RedHat7,h_rt=24:00:00,h_vmem=30g
#$ -binding linear:1
#$ -pe smp 1



#LD clump variants from previous GWAS study 


chr=$SGE_TASK_ID

while read phenos; do 

plink19="/broad/hirschhorn/SOFTWARE/PLINK2/plink2"
sumstats="/broad/sankaranlab/elw/blood_traits/phenos_combined_new/${phenos}_COMBINED.txt"
plinkfile="/broad/sankaranlab/UK10K_1000GP3/UK10K_1000GP3_MERGED.20160410.chr${chr}.vcf.gz"
outdir="/broad/sankaranlab/elw/LD_clump/new"
r2_thresh=0.001
pthresh=1

#echo $phenos
#echo $sumstats


 $plink19 --vcf ${plinkfile} --clump ${sumstats} \
 --clump-p1 ${pthresh} \
 --clump-r2 ${r2_thresh} \
 --clump-kb 250 \
 --clump-snp-field UKID \
 --clump-field P_BOLT_LMM \
 --memory 30000 \
 --out $outdir/${phenos}.chr${chr}.LD${r2_thresh}.temp  

 cat $outdir/${phenos}.chr${chr}.LD0.001.temp.clumped | sed -e 's/^[[:space:]]*//' | sed 's/ \+ /\t/g' | sed '/^[[:space:]]*$/d' > $outdir/${phenos}/${phenos}.chr${chr}.clumped

 cat $outdir/${phenos}/${phenos}.chr*.clumped >> $outdir/${phenos}/${phenos}.combined

done < /broad/sankaranlab/ebao/ukbb_500k/blood_traits/phenos/bloodtraits.txt    




