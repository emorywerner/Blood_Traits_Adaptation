#$ -cwd
#$ -q broad
#$ -N make_freqsß
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

dir="/broad/sankaranlab/elw/PolyTestFiles/Correct"


echo -e "SNP" "\t" "CLST" "\t" "A1" "\t" "A2" "\t" "FRQ" "\t" "POS" "\t" "CHR" "\t" "ID" > ${dir}/${phenos}.freq.txt

cat /broad/sankaranlab/elw/PolyTestFiles/${phenos}.freqs.txt |tail -n +2 | awk '{print $8, $7, $4, $5, $6, $2, $1, $3}' | sed 's/ /\t/g' >> ${dir}/${phenos}.freq.txt


echo -e "SNP" "\t" "CLST" "\t" "A1" "\t" "A2" "\t" "FRQ" "\t" "POS" "\t" "CHR" "\t" "ID" > /broad/sankaranlab/elw/PolyTestFiles/Correct/NEUTRO_COUNT.freq.txt

cat /broad/sankaranlab/elw/PolyTestFiles/NEUTRO_COUNT.freqs.txt |tail -n +2 | awk '{print $8, $7, $4, $5, $6, $2, $1, $3}' | sed 's/ /\t/g' >> /broad/sankaranlab/elw/PolyTestFiles/Correct/NEUTRO_COUNT.freq.txt