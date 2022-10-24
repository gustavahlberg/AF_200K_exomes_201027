# ---------------------------------------------
#
# add cadd annotations
#
# ---------------------------------------------
#
# load
#


vcftab_fn <- paste0("intermediate/vcf4cadd_chr", chr, ".vcf")
vcftab <- read.table(vcftab_fn,
                      header = F,
                      sep = "\t")



caddtab_fn <- paste0("intermediate/vcf4cadd_chr", chr, ".tsv.gz")

caddtab <- read.table(caddtab_fn,
                      header = T,
                      sep = "\t",
                      skip = 1,
                      comment.char = "@")

# ---------------------------------------------
#
# get scores
#

idxdup <- which(duplicated(vcftab[,-3]))
if (0 < length(idxdup)) {
    vcftab_xtra <- vcftab[idxdup, ]
    vcftab <- vcftab[-idxdup, ]
}


caddtab$markername <- paste(caddtab$Pos, caddtab$Ref, caddtab$Alt, sep = "_")

idxDup <- which(duplicated(caddtab$markername))
caddtab <- caddtab[-idxDup, ]

vcftab$markername <- paste(vcftab$V2, vcftab$V4, vcftab$V5, sep = "_")

all(vcftab$markername %in% caddtab$markername)

vcftab <- vcftab[match(caddtab$markername, vcftab$markername), ]
all(vcftab$markername == caddtab$markername)

vcftab$PHRED <- caddtab$PHRED
vcftab$RawScore <- caddtab$RawScore
vcftab$dbscSNV.rf_score <- caddtab$dbscSNV.rf_score
vcftab$dbscSNV.ada_score <- caddtab$dbscSNV.ada_score

# put back duplicated
if (0 < length(idxdup)) {
    vcftab_xtra$markername <- paste(vcftab_xtra$V2,
                                    vcftab_xtra$V4,
                                    vcftab_xtra$V5,
                                    sep = "_")

    cadd_sub <- caddtab[caddtab$markername == vcftab_xtra$markername, ]
    vcftab_xtra$PHRED <- cadd_sub$PHRED
    vcftab_xtra$RawScore <- cadd_sub$RawScore
    vcftab_xtra$dbscSNV.rf_score <- cadd_sub$dbscSNV.rf_score
    vcftab_xtra$dbscSNV.ada_score <- cadd_sub$dbscSNV.ada_score

    vcftab <- rbind(vcftab, vcftab_xtra)
}


# ---------------------------------------------
#
# add scores
#

load(paste0("intermediate/infotab_chr", chr, ".Rdata"), verbose = T)

rownames(vcftab) <- vcftab$V3
#unique(tab$varid)

vcftab <- vcftab[tab$varid, ]

#idxNa <- which(is.na(vcftab$V3))

all(vcftab$V3 == tab$varid)

tab <- cbind(tab, vcftab[, c("PHRED", "RawScore", "dbscSNV.rf_score", "dbscSNV.ada_score")])


# ---------------------------------------------
#
# save
#


save(tab, file = paste0("results/infotab_chr", chr, ".Rdata"))



###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################
