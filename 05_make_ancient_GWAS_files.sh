#$ -cwd
#$ -q broad
#$ -N make_GWAS
#$ -t 1-21
#$ -tc 21
#$ -o logs/
#$ -e logs/
#$ -l os=RedHat7,h_rt=1:00:00,h_vmem=30g
#$ -binding linear:1
#$ -pe smp 1

phenos_list="/broad/sankaranlab/elw/blood_traits/blood_traits/phenos.txt"
length="$(wc -l $phenos | awk '{print $1}')"
phenos="$(cat $phenos_list | tail -n +2 | awk -v ln="${SGE_TASK_ID}" "NR==ln" | awk '{print $2}')"

dir="/broad/sankaranlab/elw/MathiesonAF/PolyTestFiles"

#awk '{FS = "[ \t]"} {if ($13 <= 1E-6) {print $0}}' /broad/sankaranlab/elw/LD_clump/new/clumps/min.new/min.${phenos}.clumps.txt > /broad/sankaranlab/elw/LD_clump/new/clumps/min.old/min.${phenos}.clumps.filtered.txt


#echo -e "SNP" "\t" "A1" "\t" "A2" "\t" "EFF" "\t" "FRQ" > ${dir}/GWAS/${phenos}.GWAS.txt

#cat /broad/sankaranlab/elw/LD_clump/new/clumps/min.old/min.${phenos}.clumps.filtered.txt | tail -n +2 | awk '{print $3, $7, $8, $11, $9}' | sed 's/ /\t/g' >> ${dir}/GWAS/${phenos}.GWAS.txt


echo -e "SNP" "\t" "A1" "\t" "A2" "\t" "EFF" "\t" "FRQ" > ${dir}/GWAS/${phenos}.GWAS.txt
awk 'FNR==NR { a[$1]; next } ($1 in a) {print $0}' ${dir}/freq/${phenos}.freq.txt ${dir}/GWAS/unfiltered/${phenos}.GWAS.txt >> ${dir}/GWAS/${phenos}.GWAS.txt

awk 'FNR==NR { a[$1]; next } ($1 in a) {print $0}' /broad/sankaranlab/elw/MathiesonAF/PolyTestFiles/freq/MPV.freq.txt /broad/sankaranlab/elw/MathiesonAF/PolyTestFiles/GWAS/unfiltered/MPV.GWAS.txt > /broad/sankaranlab/elw/MathiesonAF/PolyTestFiles/GWAS/MPV2.GWAS.txt



