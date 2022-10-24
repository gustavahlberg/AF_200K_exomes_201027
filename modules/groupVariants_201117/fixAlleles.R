#
# fix alleles to normalized left aligned
#
# ---------------------------------------------
#
# Set relative path an source enviroment
#

rm(list = ls())
set.seed(100)
DIR <- system(intern = TRUE, ignore.stderr = TRUE,
           "cd \"$( dirname \"${BASH_SOURCE[0]}\" )\" && pwd ")

args <- commandArgs(trailingOnly = TRUE)
i <- as.numeric(args[1])
print(i)

library(SeqVarTools)

gds_fns <- list.files("../../data/gds",
                     pattern = "v1.filter.miss.gds",
                     full.names = T)



# ---------------------------------------------
#
# load
#

i <- 15

gdsfn <- gds_fns[i]
gds <- seqOpen(gds.fn = gdsfn, readonly = FALSE)

chr <- gsub("ukb23156_c(\\d+)_v1.+",
           "\\1",
           basename(gdsfn))

gdssets_fn <- paste0("../../data/gds/ukb23156_c",
                    chr,
                    "_v1.filter.miss.onlyinfo.annon.dbnsfp.geneset.gds")


gset <- seqOpen(gds.fn = gdssets_fn)



# ---------------------------------------------
#
# fix alleles 
#

varid_1 <- seqGetData(gset, "annotation/info/VARID")
pos <- seqGetData(gset, "position")
alleles <- seqGetData(gset, "allele")

varid_2 <- seqGetData(gds, "annotation/info/VARID")
#pos <- seqGetData(gset, "position")



idx_varid <- match(varid_2, varid_1)

if (!(all(varid_1 %in% varid_2) & all(varid_1[idx_varid] == varid_2)) ) {
    print("var ids are not matching")
    q(save = "no")
}


pos_2 <- pos[idx_varid] 
allele_2 <- allele[idx_varid]

