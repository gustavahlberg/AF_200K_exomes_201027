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
set.seed(100)


gdsfile="../../data/ukbSubset.filtered.gds"
gds <- seqOpen(gdsfile)

gdsKing.fn  = "results/kingRobustMat.gds"
gdsKing <- openfn.gds(gdsKing.fn)


# --------------------------------------------------------
#
# PC
#


sampset <- pcairPartition(kinobj = gdsKing, kin.thresh=2^(-9/2),
                          divobj = gdsKing, div.thresh=-2^(-9/2))

pca.unrel <- snpgdsPCA(gds,
                       sample.id=sampset$unrels,
                       snp.id=pruned,
                       maf = 0.05,
                       num.thread = 20)


# project values for relatives
snp.load <- snpgdsPCASNPLoading(pca.unrel,
                                gdsobj=gds,
                                num.thread = 20)

samp.load <- snpgdsPCASampLoading(snp.load,
                                  gdsobj=gds,
                                  sample.id=sampset$rels,
                                  num.thread = 20)


# combine unrelated and related PCs and order as in GDS file
pcs <- rbind(pca.unrel$eigenvect, samp.load$eigenvect)
rownames(pcs) <- c(pca.unrel$sample.id, samp.load$sample.id)
samp.ord <- match(sample.king.id, rownames(pcs))
pcs <- pcs[samp.ord,]


# --------------------------------------------------------
#
# save PC-air
#


date = format(Sys.time(), "%y%m%d")
save(file = paste0("results/pcs_round1_", date, ".rda"),
     pcs)



#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################







