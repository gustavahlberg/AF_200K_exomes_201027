#
# Run PC relate beta
#
# --------------------------------------------------------
#
# load
#

library(SeqVarTools)
library(GENESIS)
load("results/pcs_round1_201106.rda", verbose = TRUE)
#sessionInfo()

n_pcs = 4
"sample_include_file"=NA
variant_block_size=1024
" variant_include_file"=NA

gdsfile="../../data/ukbSubset.filtered.gds"
gds <- seqOpen(gdsfile)
seqData <- SeqVarData(gds)


load("results/pca_round1_201110.rda", verbose = TRUE)
pcs <- as.matrix(pca$vectors[,1:n_pcs])

sample.include <- samplesGdsOrder(seqData, pca$unrels)

# --------------------------------------------------------
#
# create iterator
#


# create iterator
block.size <- as.integer(variant_block_size)
iterator <- SeqVarBlockIterator(seqData, variantBlock=block.size)


# --------------------------------------------------------
#
# calc beta
#


beta <- calcISAFBeta(iterator,
                     pcs=pcs,
                     sample.include=sample.include)

save(beta, file=paste0("results/pcrelate_beta", ".RData"))

seqClose(seqData)


# mem stats
ms <- gc()
cat(">>> Max memory: ", ms[1,6]+ms[2,6], " MB\n")


#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################
