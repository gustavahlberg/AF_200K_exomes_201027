# ---------------------------------------------
#
# add external maf annotations
#
# ---------------------------------------------

library(GenomicScores)
library(MafDb.gnomADex.r2.1.GRCh38)

seqSetFilter(gds, variant.id = as.numeric(unique(infomat$varid)))
variantid <- seqGetData(gds, var.name = "variant.id")

gr <- granges(gds)
allele <- seqGetData(gds, "allele")
allele <- do.call(rbind, strsplit(allele, ","))



mafdb <- MafDb.gnomADex.r2.1.GRCh38
# detach("package:SeqArray", unload = TRUE)
populations(mafdb)

popmax <- gscores(mafdb, gr,
                  pop = "AF_popmax")

afpopmax <- popmax$AF_popmax
names(afpopmax) <- names(popmax)

infomat$gnomad_popmax_af <- afpopmax[infomat$varid]



#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################
