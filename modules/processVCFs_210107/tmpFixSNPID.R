# ----------------------
#
# temporary fix for snp ids (PCSK9)
#
# ----------------------


library("SeqVarTools")

library(SeqArray)

gds_fn <- "/home/projects/cu_10039/projects/AF_200K_exomes_201027/data/gds/tmpFix_c1_v1.filter.miss.norm.gds"

gds <- seqOpen(gds_fn, readonly = FALSE)



# ----------------------
#
# temporary fix for snp ids (PCSK9)
#


chr <- "chr1"
pos <- seqGetData(gds, "position")
allele <- seqGetData(gds, "allele")

allele <- gsub(",", "_", allele)

id <- paste(chr, pos, allele, sep = "_")


seqAddValue(gds, varnm = "annotation/id", id, replace = TRUE)


seqClose(gds)

