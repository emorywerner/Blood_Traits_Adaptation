setwd("/broad/sankaranlab/elw/LD_clump/new/clumps/")
require(dplyr)
require(tidyr)
require(data.table)
require(readr)

#chose SNP from clump with the lowest p value to be the represntative SNP


# read in files (make sure wont try to re-process min files if run again)
files <- list.files(".")
files <- files[!grepl("min", files)]


# function to process
process_min <- function(file, names_cols){
      # there are less col names than cols; looks like a second SNP id exists:
      # SNP --> SNP1 and SNP2
      names_cols <- c("UKID", "SNP1", "SNP2", "CHR", "BP", "GENPOS", "ALLELE1", "ALLELE0", "A1FREQ",
                      "INFO", "BETA", "SE", "P_BOLT_LMM_INF", "P_BOLT_LMM", "CLUMP")
      
      curr <- fread(file, skip = 1, col.names = names_cols) %>% data.frame(., stringsAsFactors = F)
      out <- curr %>%
            group_by(CLUMP) %>%
            filter(P_BOLT_LMM_INF == min(P_BOLT_LMM_INF)) %>%
            ungroup(.)
      #also write out
      write_tsv(out, path = paste0("min.", file))
      out
}

# also make into dataframe and add column for the trait
l <- lapply(files, process_min)
names(l) <- files %>% gsub(".clumps.txt", "", .)
combined <- bind_rows(l, .id = "id")
write_tsv(combined, path = "min.combined.txt")

