#$ -cwd
#$ -q broad
#$ -N combine
#$ -t 1
#$ -tc 1
#$ -o logs/
#$ -e logs/
#$ -l os=RedHat7,h_rt=24:00:00,h_vmem=8g
#$ -binding linear:1
#$ -pe smp 1

outdir="/broad/sankaranlab/elw/null_pheno/duplicates/december/bolt/clumped"
dir="/broad/sankaranlab/elw/null_pheno/duplicates/december/bolt/"

#cat ${outdir}/chr1.clumped head -1 > ${outdir}/combined.clumped

#cat ${outdir}/chr*.clumped |\
#awk '!seen[$0]++' >> ${outdir}/combined.clumped

#filter bolt results for p value

#echo -e "rsid" "\t" "A1" "\t" "beta" "\t" "UKID" >  ${dir}/null_filtered.txt

#cat ${dir}/bolt_combined_UKID.txt |\
#awk '{if ($12 <= 5.0E-8) print $1, $5, $9, $13}' >> ${dir}/null_filtered.txt

cat ${dir}/null_filtered.txt | head -1 > ${dir}/null_filtered_clumped.txt
awk 'FNR==NR { a[$3]; next } ($4 in a) {print $0}' ${outdir}/combined.clumped ${dir}/null_filtered.txt >> ${dir}/null_filtered_clumped.txt