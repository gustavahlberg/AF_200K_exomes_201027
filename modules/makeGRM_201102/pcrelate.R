#
# Run PC relate
#
# --------------------------------------------------------
#
# load
#

library(SeqVarTools)
library(GENESIS)
library(GWASTools)


gdsfile= "../../data/ukbSubset.filtered.gds"
pcaFile = "results/pca_round1_201110.rda"
betaFile = "results/pcrelate_beta.RData"
prunedFile = "results/pruned_201105.rda.gz"


load(file = "results/segments.RData", verbose = T)
load(prunedFile, verbose = T)
beta <- getobj(betaFile)
pca <- getobj(pcaFile)
gds <- seqOpen(gdsfile)
seqData <- SeqVarData(gds)

args = commandArgs(trailingOnly=TRUE)
segment = as.numeric(args[1])
n_pcs = 4
block.size <- 1024
kin.thresh = 2^(-13/2)


pcs <- as.matrix(pca$vectors[,1:n_pcs])
sample.include <- samplesGdsOrder(seqData, rownames(pcs))

print(paste("Running segment no:", segment))

# --------------------------------------------------------
#
# create iterator
#

seqSetFilter(seqData, variant.id = pruned)
iterator <- SeqVarBlockIterator(seqData, variantBlock=block.size)


# --------------------------------------------------------
#
# Run pcrelate
#

i <- jobs[[segment]][1]
j <- jobs[[segment]][2]

out <- pcrelateSampBlock(iterator,
                         betaobj=beta,
                         pcs=pcs,
                         sample.include.block1=samp.blocks[[i]],
                         sample.include.block2=samp.blocks[[j]])



# --------------------------------------------------------
#
# Filter kin
#


kinBtwn = out$kinBtwn[kin > kin.thresh]

pcrelobj <- list(kinSelf = out$kinSelf, kinBtwn = kinBtwn)
class(pcrelobj) <- "pcrelate"


# --------------------------------------------------------
#
# Save
#


save(pcrelobj, file=paste0("intermediate/pcrelate", "_block_", i, "_", j, ".RData"))

print(paste0("Finished job:", i,"_", j))

###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################
