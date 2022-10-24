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
load("results/pruned_201105.rda.gz")

date = format(Sys.time(), "%y%m%d")
gdsfile="../../data/ukbSubset.filtered.gds"
gds <- seqOpen(gdsfile)

gdsKing.fn  = "results/kingRobustMat.gds"
gdsKing <- openfn.gds(gdsKing.fn)

n_pcs=20
nt=12

# --------------------------------------------------------
#
# Partition
#

#sampset <- pcairPartition(kinobj = gdsKing, kin.thresh=2^(-11/2),
#                          divobj = gdsKing, div.thresh=-2^(-11/2))
#save(sampset, file = "results/related_unrelated.RData")

# --------------------------------------------------------
#
# PC
#

load("results/related_unrelated.RData", verbose = T)

#pca.unrel <- snpgdsPCA(gds,
#                       sample.id = sampset$unrels,
#                       algorithm = "randomized",
#                       eigen.cnt = n_pcs,
#                       num.thread = nt,
#                       snp.id = pruned,
#                       maf = 0.05,
#                       missing.rate = 0.01 
#                       )

#save(file = paste0("results/pca_unrel1_", date, ".rda"),
#     pca.unrel)

load("results/pca_unrel1_201110.rda", verbose = TRUE)

# project values for relatives
snp.load <- snpgdsPCASNPLoading(pca.unrel,
                                gdsobj=gds,
                                num.thread = nt)

samp.load <- snpgdsPCASampLoading(snp.load,
                                  gdsobj=gds,
                                  sample.id=sampset$rels,
                                  num.thread = nt)



sample.king.id <- read.gdsn(index.gdsn(gdsKing, "sample.id"))
# combine unrelated and related PCs and order as in GDS file
pcs <- rbind(pca.unrel$eigenvect, samp.load$eigenvect)
rownames(pcs) <- c(pca.unrel$sample.id, samp.load$sample.id)
samp.ord <- match(sample.king.id, rownames(pcs))
pcs <- pcs[samp.ord,]

pca <- list(vectors=pcs,
            values=pca.unrel$eigenval[1:n_pcs],
            varprop=pca.unrel$varprop[1:n_pcs],
            rels=sampset$rels,
            unrels=sampset$unrels)

# --------------------------------------------------------
#
# save PC-air
#


save(file = paste0("results/pca_round1_", date, ".rda"),
     pca)

seqClose(gds)


#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################








