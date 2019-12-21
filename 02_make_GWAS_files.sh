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

dir="/broad/sankaranlab/elw/PolyTestFiles/Correct"


echo -e "SNP" "\t" "A1" "\t" "A2" "\t" "EFF" "\t" "FRQ" > ${dir}/${phenos}.GWAS.txt

cat /broad/sankaranlab/elw/PolyTestFiles/${phenos}.GWAS.txt | tail -n +2 | awk '{print $1, $5, $6, $9, $7}' | sed 's/ /\t/g' >> ${dir}/${phenos}.GWAS.txt