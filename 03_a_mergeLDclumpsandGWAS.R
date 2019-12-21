#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

library(data.table)

GWAS<- fread(args[2])
LD <- fread(args[3], header=TRUE)

colnames(LD) <- c("UKID", "CLUMP")

merged <- merge(GWAS, LD)

write.table(merged, file = paste("/broad/sankaranlab/elw/LD_clump/new/clumps/", args[1], ".clumps.txt", sep = "") , col.names = T, quote = F, sep = "\t")



