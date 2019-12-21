#$ -cwd
#$ -q broad
#$ -N make_freq
#$ -t 1-19
#$ -tc 19
#$ -o logs/
#$ -e logs/
#$ -l os=RedHat7,h_rt=1:00:00,h_vmem=30g
#$ -binding linear:1
#$ -pe smp 1

phenos_list="/broad/sankaranlab/elw/blood_traits/blood_traits/phenos.txt"
length="$(wc -l $phenos | awk '{print $1}')"
phenos="$(cat $phenos_list | tail -n +2 | awk -v ln="${SGE_TASK_ID}" "NR==ln" | awk '{print $2}')"

dir="/broad/sankaranlab/elw/MathiesonAF/PolyTestFiles"
Math="/broad/sankaranlab/elw/MathiesonAF/all_freqs_UKID.txt"

#first filter for what is in the new GWAS files

#awk 'FNR==NR { a[$1]; next } ($1 in a) {print $0}' ${dir}/GWAS/${phenos}.GWAS.txt ${Math} > /broad/sankaranlab/elw/MathiesonAF/sep26.filtered.freqs/${phenos}.txt


#now make files
echo -e "SNP" "\t" "CLST" "\t" "A1" "\t" "A2" "\t" "FRQ" "\t" "POS" "\t" "CHR" "\t"  > ${dir}/freq/${phenos}.freq.txt

cat /broad/sankaranlab/elw/MathiesonAF/sep26.filtered.freqs/${phenos}.txt | awk '{print $1, $6, $4, $5, $7, $3, $2}' | sed 's/ /\t/g' >> ${dir}/freq/${phenos}.freq.txt


