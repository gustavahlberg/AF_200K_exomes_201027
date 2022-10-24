# ----------------------
#
# seqMerge
#
# ----------------------


library(SeqArray)
library("SeqVarTools")

# ----------------------
#
# list files
#


gds_fns <- list.files(path = "intermediate", "filter.miss.norm.gds",
                      full.names = T)
gdsmerged <- paste0("../../data/ukb23156_ALL_v1.filter.miss.norm.gds")


# ----------------------
#
# sort gds list 
#

o <- as.numeric(gsub("intermediate/ukb23156_c(\\d+)_v1.filter.miss.norm.gds",
                     "\\1", gds_fns))
gds_fns <- gds_fns[order(o)] 


# ----------------------
#
# merge files
#


gdsfile_tmp <- tempfile()
message("gds temporarily located at ", gdsfile_tmp)

# merge 
seqMerge(gds_fns, gdsfile_tmp, storage.option = "LZMA_RA")

# copy it
file.copy(gdsfile_tmp, gdsmerged)
# remove the tmp file
file.remove(gdsfile_tmp)

# ----------------------
#
# quick fix of bug 290121
#

# vcf_fn <- paste0("intermediate/ukb23156_c", chr,
#                  "_b0_v1.filter.miss.recode.vcf.gz")
# header <- seqVCF_Header(vcf_fn)

## f <- seqOpen(gdsmerged, readonly <- F)


## node <- index.gdsn(f, "annotation/filter")
## s <- get.attr.gdsn(node)$Description
## put.attr.gdsn(node, "Description", c(unique(s), "NA is ."))
## filterlevels <- header$filter$ID

## put.attr.gdsn(node, "R.class", "factor")
## put.attr.gdsn(node, "R.levels", c(filterlevels, "NA"))


## node <- index.gdsn(f, "description/vcf.contig")
## contigs <- gsub("chr", "", read.gdsn(node)$ID)

## add.gdsn(node, "ID", val = contigs,
##          compress= "LZMA_ra", closezip=TRUE,
##          replace = TRUE)



## seqClose(f)
## cleanup.gds(gdsmerged)


#####################################
# EOF # EOF # EOF # EOF # EOF # EOF #
#####################################

