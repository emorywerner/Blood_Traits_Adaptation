popfreq3file ="/Volumes/broad_sankaranlab/elw/PolyTestFiles/RBC_COUNT.freqs.txt"
popfreq3 <- read_table2(popfreq3file)
dat3file="/Volumes/broad_sankaranlab/elw/PolyTestFiles/RBC_COUNT.GWAS.txt"
dat3 <- read_table2(dat3file)
popfreq3 = popfreq3 %>% transmute(country=CLST, MAF=FREQ, A1=REF, rsid=SNP)
dat3 = dat3 %>% transmute(rsid=SNP, A1=ALLELE1, beta=BETA)

library(data.table)
library(tidyverse)
library(magrittr)

va = function(beta, meanafs) {
  2*sum(beta^2 * meanafs * (1-meanafs))
}

get_F = function(popfrqs) {
  # popfrqs is a data.frame and has columns country, rsid, MAF
  M = length(unique(popfrqs$country))
  K = length(unique(popfrqs$rsid))
  Tmat = matrix(-1/M, M-1, M)
  diag(Tmat) = (M-1)/M
  G = popfrqs %>% select(country, rsid, MAF) %>% spread(rsid, MAF)
  countries = G$country
  G %<>% select(-country) %>% as.matrix
  G = sapply(1:ncol(G), function(i) replace(G[,i], is.na(G[,i]), mean(G[,i], na.rm = TRUE)))
  meanafs = colMeans(G)
  G = G[,meanafs > 0 & meanafs < 1]
  meanafs = meanafs[meanafs > 0 & meanafs < 1]
  S = diag(1/(meanafs*(1-meanafs)))
  Fmat = (Tmat %*% G %*% S %*% t(G) %*% t(Tmat))/(K-1)
  colnames(Fmat) = rownames(Fmat) = countries[-length(countries)]
  Fmat
}

get_meanaf = function(popfrqs) {
  popfrqs %>% group_by(rsid) %>% summarize(A1 = unique(A1), mn = mean(MAF))
}


Qx_ZFVa = function(Zprime, Fmat, va) {
  (t(Zprime) %*% solve(Fmat) %*% Zprime)/(2*va)
}

Zprime = function(Z) {
  M = length(Z)
  Tmat = matrix(-1/M, M-1, M)
  diag(Tmat) = (M-1)/M
  Tmat %*% Z
}

Qx_pval = function(stat, numpops) {
  # stat: Qx statistic; numpops: number of populations
  pchisq(stat, df=numpops-1, lower.tail = F)
}

Qx = function(scoresnps, freqs) {
  # scoresnps: data.frame with rsid, beta (for exactly those SNPs that went into the scores)
  # freqs: data.frame with country, rsid, MAF
  # assumes reference alleles are the same for MAF and betas
  
  
  #Zdat <- freqs %>% select(-A1) %>% left_join(scoresnps, by='rsid') %>% mutate(aftimesbeta = MAF*beta) %>% group_by(country) %>% summarize(mn = mean(aftimesbeta))
  
  Zdat <- freqs %>% select(-A1) %>% left_join(scoresnps, by='rsid') %>% group_by(country) %>% mutate(aftimesbeta = MAF*beta*n()*2) %>% summarize(mn = mean(aftimesbeta))
  
  countries = Zdat$country
  Z = Zdat$mn
  Zp = Zprime(Z)
  M = length(countries)
  
  freqs = filter(freqs, rsid %in% scoresnps$rsid, country %in% countries)
  
  Fmat = get_F(freqs)
  stopifnot(all(colnames(Fmat) == countries[-M]))
  meanafs = get_meanaf(freqs)
  scoresnps = left_join(scoresnps, transmute(meanafs, rsid, a1=A1, mn), by='rsid') %>% mutate(mn = ifelse(a1==A1, mn, 1-mn))
  scoresnps <- na.omit(scoresnps)
  
  v_a = va(scoresnps$beta, scoresnps$mn)
  
  qx_stat = Qx_ZFVa(Zp, Fmat, v_a)
  qx_pval = Qx_pval(qx_stat, M)
  
  
  #c(qx_stat=qx_stat, qx_pval=qx_pval)
  

  #trait <- print(trait)
  #qx_stat <- print(qx_stat)
  #qx_pval <- print(qx_pval)
  df <- data.frame(qx_stat, qx_pval)
  names(df) <- NULL 
  print(df)

}



# run phenos loop ---------------------------------------------------------

library(data.table)
library(dplyr)
phenos <- fread("/Volumes/broad_sankaranlab/elw/blood_traits/blood_traits/phenos.txt", header = TRUE, row.names(FALSE))
phenos <- phenos$trait

Qx_value <- for (trait in phenos ) {
  popfreqfile = paste("/Volumes/broad_sankaranlab/elw/PolyTestFiles/", trait, ".freqs.txt", sep ="")
  popfreq <- read_table2(popfreqfile)
  datfile=paste("/Volumes/broad_sankaranlab/elw/PolyTestFiles/", trait, ".GWAS.txt", sep ="")
  dat <- read_table2(datfile)
  popfreq = popfreq %>% transmute(country=CLST, MAF=FREQ, A1=REF, rsid=SNP)
  dat = dat %>% transmute(rsid=SNP, A1=ALLELE1, beta=BETA)
  datnew <- na.omit(dat)
  popfreqnew <- na.omit(popfreq)
  
  Qx_value$trait <- trait
  Qx_value$Qx <- Qx(datnew, popfreqnew) 

}





stat <- lapply(phenos, function(trait){
  popfreqfile <- paste("/Volumes/broad_sankaranlab/elw/PolyTestFiles/", trait, ".freqs.txt", sep ="")
  popfreq <- read_table2(popfreqfile)
  datfile <- paste("/Volumes/broad_sankaranlab/elw/PolyTestFiles/", trait, ".GWAS.txt", sep ="")
  dat <- read_table2(datfile)
  popfreq = popfreq %>% transmute(country=CLST, MAF=FREQ, A1=REF, rsid=SNP)
  dat = dat %>% transmute(rsid=SNP, A1=ALLELE1, beta=BETA)
  datnew <- na.omit(dat)
  popfreqnew <- na.omit(popfreq)
  Qx(datnew, popfreqnew)

} )

write.table(stat, "/Users/emorywerner/Desktop/stat.txt")
qx <- fread("/Users/emorywerner/Desktop/stat.txt")
df <- data.frame(phenos, qx)
names(df)[1] <- paste("trait")
names(df)[2] <- paste("Qx")
names(df)[3] <- paste("p")

write.table(df, "/Volumes/broad_sankaranlab/elw/Qx_scores/1000GP/Q.txt", row.names = FALSE, col.names = TRUE, sep = "\t")

#sed 's/"//g' Q.txt > Qx.txt



# Ancient -----------------------------------------------------------------

stat <- lapply(phenos, function(trait){
  popfreqfile <- paste("/Volumes/broad_sankaranlab/elw/MathiesonAF/PolyTestFiles/freq/", trait, ".freq.txt", sep ="")
  popfreq <- read_table2(popfreqfile)
  datfile <- paste("/Volumes/broad_sankaranlab/elw/MathiesonAF/PolyTestFiles/GWAS/", trait, ".GWAS.txt", sep ="")
  dat <- read_table2(datfile)
  popfreq = popfreq %>% transmute(country=CLST, MAF=FRQ, A1=A1, rsid=SNP)
  dat = dat %>% transmute(rsid=SNP, A1=A1, beta=EFF)
  datnew <- na.omit(dat)
  popfreqnew <- na.omit(popfreq)
  Qx(datnew, popfreqnew)
  
} )

write.table(stat, "/Users/emorywerner/Desktop/stat.txt")

write.table(df, "/Volumes/broad_sankaranlab/elw/Qx_scores/Ancient/Q.txt", row.names = FALSE, col.names = TRUE, sep = "\t")


# MPV ---------------------------------------------------------------------


popfreqfile <- "/Volumes/broad_sankaranlab/elw/MathiesonAF/PolyTestFiles/freq/MPV.freq.txt"
popfreq <- read_table2(popfreqfile)
datfile <- "/Volumes/broad_sankaranlab/elw/MathiesonAF/PolyTestFiles/GWAS/MPV.GWAS.txt"
dat <- read_table2(datfile)
popfreq = popfreq %>% transmute(country=CLST, MAF=FRQ, A1=A1, rsid=SNP)
dat = dat %>% transmute(rsid=SNP, A1=A1, beta=EFF)
datnew <- na.omit(dat)
popfreqnew <- na.omit(popfreq)
datfilt <- datnew %>% filter(rsid %in% popfreqnew$rsid)
popfreqfil <- popfreqnew %>% filter(rsid %in% datfilt$rsid)
Qx(datfilt, popfreqfil)

