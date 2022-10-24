# ---------------------------------------------
#
# save tab
#
# ---------------------------------------------


rownames(allele) <- names(gr)
colnames(allele) <- c("ref", "alt")
tab <- cbind(gr[infomat$varid, ], allele[infomat$varid, ], infomat)


vcf_fn <- paste0("intermediate/vcf4cadd_chr", chr, ".vcf")
info_fn <- paste0("intermediate/infotab_chr", chr, ".Rdata")


vcf <- data.frame(CHROM = tab$seqnames,
                  POS = tab$start,
                  ID = tab$varid,
                  REF = tab$ref,
                  ALT = tab$alt
                  )
vcf <- unique(vcf)    


# save
save(file = info_fn,
     tab)

write.table(file = vcf_fn,
            x = vcf,
            row.names = FALSE,
            col.names = FALSE,
            quote = FALSE,
            sep = "\t"
            )

#####################################
# EOF # EOF # EOF # EOF # EOF # EOF #
#####################################
