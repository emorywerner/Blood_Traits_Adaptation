args = commandArgs(trailingOnly=TRUE)
library(tidyverse)
library(data.table)

#i think since using combined frequency files only needed to do this once and then use only that one from then on so just using one labeled with chr1 but really its a combined one

frq = fread("/broad/sankaranlab/elw/null_pheno/duplicates/december/freqs/combined_freq_new_header.frq", stringsAsFactors=FALSE, header = TRUE)
chr=(args[3])

alpha = as.numeric(args[1])
i = as.numeric(args[2])
 
# simulate effect sizes
#had MAF here changed to ALT_FREQS - assuming allele frequency
#rnorm - generating random betas - third term is determing the variance of beta
beta = rnorm(nrow(frq), 0, sqrt(1/nrow(frq)*(2*frq$ALT_FREQS * (1-frq$ALT_FREQS))^alpha))
beta[!is.finite(beta)] = 0
#changed SNP to ID
data.frame(frq$ID, frq$ALT, beta) %>% unique() %>% write_tsv(paste0('/broad/sankaranlab/elw/null_pheno/duplicates/december/freqs/sim/sim_beta',chr,'.tsv'))
#make sure the args[3] is working to print out chr number 

# simulate phenotypes

#what is this bfile?
#print(paste0('/broad/sankaranlab/tools/plink2 --bpfile',plink,'--score /broad/sankaranlab/elw/null_pheno/duplicates/new/freqs/sim_beta',args[3],'.tsv --out /broad/sankaranlab/elw/null_pheno/duplicates/new/freqs/simu_g',args[3]))

#g= simulated genetic effect for each individual
#p= simulated phenotype for each individual
#g = read_table2(paste0('/broad/sankaranlab/elw/null_pheno/duplicates/new/freqs/simu_g',args[3],'.sscore'))
#random noise with SNP heritability of 0.5- because variance of added noise = variance of genetic effects
#j = scale(g$NAMED_ALLELE_DOSAGE_SUM + rnorm(nrow(g), 0, sd(g$NAMED_ALLELE_DOSAGE_SUM)))[,1]
#data.frame(FID=fam[[1]], IID=fam[[2]], j) %>% write_tsv(paste0('/broad/sankaranlab/elw/null_pheno/duplicates/new/freqs/simu_p',args[3],'.tsv'))


#print(paste0('/broad/sankaranlab/tools/plink2 --bpfile ${plink} --score /broad/sankaranlab/elw/null_pheno/freqs/sim_beta',i,'.tsv --out /broad/sankaranlab/elw/null_pheno/freqs/simu_g',i))











