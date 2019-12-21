#$ -cwd
#$ -q broad
#$ -N combine
#$ -t 1-22
#$ -tc 22
#$ -o logs/
#$ -e logs/
#$ -l os=RedHat7,h_rt=24:00:00,h_vmem=8g
#$ -binding linear:1
#$ -pe smp 1

outdir="/broad/sankaranlab/elw/null_pheno/duplicates/december/bolt/clumped"
dir="/broad/sankaranlab/elw/null_pheno/duplicates/december/bolt/"

cat ${outdir}/chr1.clumped head -1 > ${outdir} 

#combine 

#head -1 /broad/sankaranlab/elw/null_pheno/duplicates/december/bolt/  > /broad/sankaranlab/elw/null_pheno/duplicates/new/bolt/null_combined.txt
#cat /broad/sankaranlab/elw/null_pheno/duplicates/new/bolt/chr*.txt >> /broad/sankaranlab/elw/null_pheno/duplicates/new/bolt/null_combined.txt

#add UKID column 

#head -1 /broad/sankaranlab/elw/null_pheno/duplicates/new/bolt/null_combined.txt |\
#awk 'BEGIN {OFS=FS="\t"} {print $0,"UKID"}' > /broad/sankaranlab/elw/null_pheno/duplicates/new/bolt/null_filtered_UKID.txt
#tail -n +2 /broad/sankaranlab/elw/null_pheno/duplicates/new/bolt/null_combined.txt |\
#awk 'BEGIN {OFS=FS="\t"} {print $0,$2":"$3"_"$5"_"$6}' >> /broad/sankaranlab/elw/null_pheno/duplicates/new/bolt/null_filtered_UKID.txt


#filter by p and create one combined file

echo -e "rsid" "\t" "A1" "\t" "beta" "\t" "UKID" >  ${dir}/null_filtered.txt

cat ${dir}/null_filtered.txt |\

awk '{if ($12 <= 5.0E-8) print $1, $5, $9, $13}' >> ${dir}/null_filtered.txt


#make file with only clumped variants

cat ${dir}/null_filtered.txt | head -1 > ${outdir}/null_COMBINED.txt


awk 'FNR==NR { a[$3]; next } ($4 in a) {print $0}' ${outdir}/combined.clumped /broad/sankaranlab/elw/null_pheno/duplicates/new/bolt/null_filtered.txt >> ${outdir}/null_COMBINED.txt


#awk '{if ($12 <= 5.0E-8) {print $1, $2, $3, $5, $6, $7, $9, $12}}'

#SNP     CHR     BP      GENPOS  ALLELE1 ALLELE0 A1FREQ  F_MISS  BETA    SE      P_BOLT_LMM_INF  P_BOLT_LMM

#rsid=SNP, A1=ALLELE1, beta=BETA