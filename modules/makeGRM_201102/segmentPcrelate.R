#
# Segment pc relate jobs
#
# --------------------------------------------------------
#
# configs
#

sample.block.size <- 7000


# --------------------------------------------------------
#
# load
#

library(SeqVarTools)
library(GENESIS)
library(GWASTools)

gdsfile= "../../data/ukbSubset.filtered.gds"
pcaFile = "results/pca_round1_201110.rda"
gds <- seqOpen(gdsfile)
seqData <- SeqVarData(gds)

pca <- getobj(pcaFile)
sample.include <- samplesGdsOrder(seqData, rownames(pca$vectors))

# --------------------------------------------------------
#
# create sample blocks
#


# create sample blocks
nsampblock <- ceiling(length(sample.include)/sample.block.size)
samp.blocks <- unname(split(sample.include, cut(1:length(sample.include), nsampblock)))
jobs <- c(combn(1:nsampblock, 2, simplify=FALSE),
          lapply(1:nsampblock, function(x) c(x,x)))


# --------------------------------------------------------
#
# save
#

save(nsampblock, samp.blocks, jobs,
     file = "results/segments.RData")


###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################
