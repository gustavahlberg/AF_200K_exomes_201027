#
# Run PC-air
#
# --------------------------------------------------------
#
# load
#

library(SeqArray)
library(SNPRelate)
library(GENESIS)

date <- format(Sys.time(), "%y%m%d")
gdsfile <- "../../data/ukbSubset.filtered.gds"
gds <- seqOpen(gdsfile)

gdsKing.fn  <- "results/kingRobustMat.gds"
gdsKing <- openfn.gds(gdsKing.fn)

# n_pcs=20
# nt=12


# --------------------------------------------------------
#
# Partition to 2nd and 3d degree subsets
#

cut.deg2 <- 1/(2^(7/2))
cut.deg3 <- 1/(2^(9/2))


sampset2nd <- pcairPartition(kinobj = gdsKing, kin.thresh = cut.deg2,
                             divobj = gdsKing, div.thresh = -cut.deg2)

save(sampset2nd, file = "results/degree2nd_related_unrelated.RData")


sampset3d <- pcairPartition(kinobj = gdsKing, kin.thresh = cut.deg3,
                            divobj = gdsKing, div.thresh = -cut.deg3)


save(sampset3d, file = "results/degree3nd_related_unrelated.RData")




###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################
