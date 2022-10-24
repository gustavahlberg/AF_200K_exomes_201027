#
# Run PC-air
#
# --------------------------------------------------------
#
# load
#


library(SeqArray)
library(SeqVarTools)
library(SNPRelate)
library(GENESIS)
set.seed(100)

gdsfile="../../data/ukbSubset.filtered.gds"
gds <- seqOpen(gdsfile)

gdsKing.fn  = "results/kingRobustMat.gds"
gdsKing <- openfn.gds(gdsKing.fn)


load("results/pcs_round1_201106.rda", verbose = TRUE)
load("results/pruned_201105.rda.gz", verbose = TRUE)


# --------------------------------------------------------
#
# PC-Relate
#


seqData <- SeqVarData(gds)
seqSetFilter(seqData, variant.id=pruned)
iterator <- SeqVarBlockIterator(seqData,
                                verbose= TRUE)

pcrel <- pcrelate(iterator,
                  pcs = pcs[,1:2],
                  training.set = sampset$unrel, 
                  sample.include = as.character(sample.king.id),
                  ibd.probs = FALSE
                  )


# --------------------------------------------------------
#
# PC-Air
#


pcrel <- pcrelateToMatrix(pcrel,
                          scaleKin=1,
                          verbose= TRUE,
                          thresh = 2^(-11/2)
                          )


seqResetFilter(seqData,
               verbose=FALSE)

pca <- pcair(seqData,
             kinobj = pcrel,
             kin.thresh = 2^(-9/2),
             divobj = gdsKing,
             div.thresh = -2^(-9/2),
             sample.include = as.character(sample.king.id),
             snp.include = pruned,
             num.cores = 20,
             verbose = TRUE)

pcs <- pca$vectors


# --------------------------------------------------------
#
# PC-Relate 2
#


seqResetFilter(seqData)
seqSetFilter(seqData, variant.id=pruned)
iterator <- SeqVarBlockIterator(seqData, verbose = TRUE)

pcrel <- pcrelate(iterator,
                  pcs = pcs[,1:2],
                  training.set = pca$unrels, 
                  sample.include = sample.king.id)

pcrel <- pcrelateToMatrix(pcrel,
                          scaleKin = 2,
                          verbose = TRUE,
                          thresh = 2^(-11/2)
                          )


# --------------------------------------------------------
#
# save sparse GRM & PC's
#


save(pcrel, file="data/pcrelate_kinship.RData")
