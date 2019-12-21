library(data.table)
library(tidyverse)


for (i in 1:22) {
g = read_table2(paste("/broad/sankaranlab/elw/null_pheno/duplicates/december/freqs/sim/simu_g_chr", i, ".sscore", sep=""))
p = scale(g$NAMED_ALLELE_DOSAGE_SUM + rnorm(nrow(g), 0, sd(g$NAMED_ALLELE_DOSAGE_SUM)))[,1]
data.frame(FID=g[[1]], IID=g[[2]], p) %>% write_tsv(paste("/broad/sankaranlab/elw/null_pheno/duplicates/december/freqs/sim/sim_p_chr", i, "tsv", sep=""))

}

#g= simulated genetic effect for each individual
#p= simulated phenotype for each individual
g = read_table2('/broad/sankaranlab/elw/null_pheno/duplicates/new/freqs/simu_g1.sscore')
#random noise with SNP heritability of 0.5- because variance of added noise = variance of genetic effects
p = scale(g$NAMED_ALLELE_DOSAGE_SUM + rnorm(nrow(g), 0, sd(g$NAMED_ALLELE_DOSAGE_SUM)))[,1]


data.frame(FID=fam[[1]], IID=fam[[2]], p) %>% write_tsv(paste0('/broad/sankaranlab/elw/null_pheno/duplicates/new/freqs/simu_p1.tsv'))
#may be able to make this:
#data.frame(FID=g[[1]], IID=g$IID, j) %>% write_tsv(paste0('/broad/sankaranlab/elw/null_pheno/duplicates/new/freqs/simu_p1.tsv'))



#combine new files 