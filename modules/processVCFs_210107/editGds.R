# ----------------------
#
# edit Gds
#
# ----------------------


library("SeqVarTools")
args <- commandArgs(trailingOnly=TRUE)
print(args)
gds_fn <- args[1]
# cores <- as.numeric(args[2])
# gds_fn <- "intermediate/ukb23156_c1_b0_v1.filter.miss.recode.gds"


gds <- seqOpen(gds_fn, readonly=FALSE)

sample_fn <- "../../data/samples200Kexomes.etn.201030.list"
samples <- as.character(read.table(sample_fn)$V1)


# ----------------------
#
# AC, MAF, HAF
#

# seqResetFilter(gds)
seqSetFilter(gds, sample.id = samples)

ac_ref <- alleleCount(gds, n = 0)
ac <- alleleCount(gds, n = 1)
af <- alleleFrequency(gds, n = 1)
mac <- minorAlleleCount(gds)
maf <- seqAlleleFreq(gds, minor = TRUE)
missing <- missingGenotypeRate(gds)



# ----------------------
#
# add annotations
#

seqResetFilter(gds)


seqAddValue(gds, "annotation/info/EUR_AF_ALT/", af)
seqAddValue(gds, "annotation/info/EUR_AC_ALT/", ac)
seqAddValue(gds, "annotation/info/EUR_AN/", ac + ac_ref)
seqAddValue(gds, "annotation/info/EUR_MAC/", mac)
seqAddValue(gds, "annotation/info/EUR_MAF/", maf)
seqAddValue(gds, "annotation/info/EUR_MISS/", missing)



# ----------------------
#
# rm PLN
#

seqDelete(gds, fmt.var = "PL")


# ----------------------
#
# close and clean up
#


seqClose(gds)
cleanup.gds(gds_fn)

print(paste("Finished gds", gds_fn))

###########################################
# EOF # # EOF ## EOF ## EOF ## EOF ## EOF #
###########################################
