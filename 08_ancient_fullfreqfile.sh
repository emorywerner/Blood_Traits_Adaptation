echo -e "SNP" "\t"	"CHR" "\t" "POS" "\t" "A1" "\t" "A2" "\t" "CLST" "\t" "FRQ"   > /broad/sankaranlab/elw/MathiesonAF/PolyTestFiles/fullfreqfile.txt

cat /broad/sankaranlab/elw/MathiesonAF/new_all.reads.3pop.freq | tail -n+2 >> /broad/sankaranlab/elw/MathiesonAF/PolyTestFiles/fullfreqfile.txt

