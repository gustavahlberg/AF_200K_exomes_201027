# ----------------------
#
# seqMerge
#
# ----------------------


library(SeqArray)
library("SeqVarTools")
args <- commandArgs(trailingOnly=TRUE)
print(args)
chr <- args[1]


# ----------------------
#
# list files
#


gds_fns <- list.files(path = "intermediate", "filter.miss.norm.gds", full.names = T)
gds_fns_chr  <- gds_fns[grep(paste0("ukb23156_c", chr, "_b"), gds_fns)]

gdsmerged <- paste0("../../data/gds/ukb23156_c", chr, "_v1.filter.miss.norm.gds")

# gdsmerged <- "../../data/gds/test.gds"


# ----------------------
#
# sort gds list 
#

o <- as.numeric(gsub("intermediate/ukb23156_c\\d+_b(\\d+)_v1.filter.miss.norm.gds",
                     "\\1", gds_fns_chr))
gds_fns_chr <- gds_fns_chr[order(o)] 


# ----------------------
#
# merge files
#


gdsfile_tmp <- tempfile()
message("gds temporarily located at ", gdsfile_tmp)

merge 
seqMerge(gds_fns_chr, gdsfile_tmp, storage.option = "LZMA_RA")

# copy it
file.copy(gdsfile_tmp, gdsmerged)
#remove the tmp file
file.remove(gdsfile_tmp)

print("merged")


# ----------------------
#
# quick fix of bug 290121
#


vcf_fn <- paste0("intermediate/ukb23156_c", chr,
                "_b0_v1.filter.miss.norm.vcf.gz")
header <- seqVCF_Header(vcf_fn)

f <- seqOpen(gdsmerged, readonly <- F)


node <- index.gdsn(f, "annotation/filter")
s <- get.attr.gdsn(node)$Description
put.attr.gdsn(node, "Description", c(unique(s), "NA is ."))
filterlevels <- header$filter$ID

put.attr.gdsn(node, "R.class", "factor")
put.attr.gdsn(node, "R.levels", c(filterlevels, "NA"))


node <- index.gdsn(f, "description/vcf.contig")
contigs <- gsub("chr", "", read.gdsn(node)$ID)

add.gdsn(node, "ID", val = contigs,
         compress= "LZMA_ra", closezip=TRUE,
         replace = TRUE)


seqClose(f)
cleanup.gds(gdsmerged)

print("fixed header 1")

# ----------------------
#
# quick fix add Description 030221
#

f <- seqOpen(gdsmerged, readonly <- F)
eurInfo <- c("EUR_AF_ALT", "EUR_AC_ALT", "EUR_AN", "EUR_MAC", "EUR_MAF", "EUR_MISS")

for (i in 1:length(eurInfo)) {
    node <- index.gdsn(f, paste0("annotation/info/", eurInfo[i]))
    put.attr.gdsn(node, "Description", "Annotation for ukb eur anc. sub population")
}

seqClose(f)
cleanup.gds(gdsmerged)

print("fixed header 2")
## add.gdsn(node, "ID", val = contigs,
##           compress= "LZMA_ra", closezip=TRUE,
##           replace = TRUE)



# ----------------------
#
# quick fix add variant id info 080221
#

f <- seqOpen(gdsmerged, readonly <- F)

var_id <- seqGetData(f, var.name = "variant.id")
seqAddValue(f, "annotation/info/VARID", var_id)

node <- index.gdsn(f, paste0("annotation/info/VARID"))
put.attr.gdsn(node, "Description", "gds variant id")


seqClose(f)
cleanup.gds(gdsmerged)

print("add varid to annotation info field")

# ----------------------
#
# gds 2 vcf w/o genotypes
#


# gds <- seqOpen(gdsmerged)
# seqSummary(gds)

vcfgz <- paste0("intermediate/", basename(gsub(".gds", "", gdsmerged)), ".vcf.gz")
seqGDS2VCF(gdsmerged, vcfgz, info.var = NULL, fmt.var = character(0))

print("printed vcf ")


#####################################
# EOF # EOF # EOF # EOF # EOF # EOF #
#####################################
