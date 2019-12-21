library(dplyr)
library(data.table)
df <- fread("/broad/sankaranlab/elw/MathiesonAF/new_all.reads.3pop.freq") %>%
  data.frame(., stringsAsFactors = F) 
match <- filter(df, CLST == "GBR")
colnames(match) <- c("SNP", "CHR", "POS", "A1", "A2", "CLST", "FRQ")

write.table(match, "/broad/sankaranlab/elw/MathiesonAF/PolyTestFiles/match.file.txt", col.names = T, row.names = F, quote = F, sep = "\t")
