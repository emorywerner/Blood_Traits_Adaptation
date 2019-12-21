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

chr=$SGE_TASK_ID


dir="/broad/sankaranlab/elw/null_pheno/duplicates/december/bolt/bolt_combined.txt"
outfile="/broad/sankaranlab/elw/null_pheno/duplicates/december/bolt/bolt_combined_UKID.txt"
# Add UKID columns to sumstats files
#head -1 ${dir}| awk 'BEGIN {OFS=FS="\t"} {print $0,"UKID"}' > ${outfile}
#tail -n +2 ${dir} | awk 'BEGIN {OFS=FS="\t"} {print $0, $2":"$3"_"$5"_"$6}' >> ${outfile}
#in command line:
#head -1 /broad/sankaranlab/elw/null_pheno/duplicates/december/bolt/bolt_combined.txt | awk 'BEGIN {OFS=FS="\t"} {print $0,"UKID"}' > /broad/sankaranlab/elw/null_pheno/duplicates/december/bolt/bolt_combined_UKID.txt
#tail -n +2 /broad/sankaranlab/elw/null_pheno/duplicates/december/bolt/bolt_combined.txt | awk 'BEGIN {OFS=FS="\t"} {print $0, $2":"$3"_"$5"_"$6}' >> /broad/sankaranlab/elw/null_pheno/duplicates/december/bolt/bolt_combined_UKID.txt

#first LD clump 

#plink19="/broad/hirschhorn/SOFTWARE/PLINK2/plink2"
#sumstats="/broad/sankaranlab/elw/null_pheno/duplicates/december/bolt/bolt_combined_UKID.txt"
#plinkfile="/broad/sankaranlab/UK10K_1000GP3/UK10K_1000GP3_MERGED.20160410.chr${chr}.vcf.gz"
#outdir="/broad/sankaranlab/elw/null_pheno/duplicates/december/bolt/clumped"
#r2_thresh=0.001
#pthresh=1

 #$plink19 --vcf ${plinkfile} --clump ${sumstats} \
 #--clump-p1 ${pthresh} \
 #--clump-r2 ${r2_thresh} \
 #--clump-kb 250 \
 #--clump-snp-field UKID \
 #--clump-field P_BOLT_LMM \
 #--memory 30000 \
 #--out $outdir/chr${chr}.temp  

 #get rid of white spaces

cat $outdir/chr${chr}.temp.clumped | sed -e 's/^[[:space:]]*//' | sed 's/ \+ /\t/g' | sed '/^[[:space:]]*$/d' > $outdir/combined.clumped


