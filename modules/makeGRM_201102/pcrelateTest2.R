library(SeqVarTools)
library(GENESIS)
library(GWASTools)
sessionInfo()

argp <- arg_parser("PC-Relate")
argp <- add_argument(argp, "config", help="path to config file")
argp <- add_argument(argp, "--segment", help="segment number", type="integer")
argp <- add_argument(argp, "--version", help="pipeline version number")
argv <- parse_args(argp)

n_pcs = 4
sample.block.size = 1000
segment <- ...
gdsfile= "../../data/ukbSubset.filtered.gds"
pcaFile = "results/pca_round1_201110.rda"
betaFile = "results/pcrelate_beta.RData"
prunedFile = "results/pruned_201105.rda.gz"

gds <- seqOpen(gdsfile)
seqData <- SeqVarData(gds)

load(prunedFile, verbose = T)


seqSetFilter(seqData, variant.id = pruned)
pca <- getobj(pcaFile)

pcs <- as.matrix(pca$vectors[,1:n_pcs])
sample.include <- samplesGdsOrder(seqData, rownames(pcs))


# load betas
beta <- getobj(betaFile)

# create iterator
block.size <- 1024
iterator <- SeqVarBlockIterator(seqData, variantBlock=block.size)

# create sample blocks
nsampblock <- ceiling(length(sample.include)/sample.block.size)
#nsampblock <- as.integer(config["n_sample_blocks"])
samp.blocks <- unname(split(sample.include, cut(1:length(sample.include), nsampblock)))
jobs <- c(combn(1:nsampblock, 2, simplify=FALSE),
          lapply(1:nsampblock, function(x) c(x,x)))

i <- jobs[[segment]][1]
j <- jobs[[segment]][2]


out <- pcrelateSampBlock(iterator,
                         betaobj=beta,
                         pcs=pcs,
                         sample.include.block1=samp.blocks[[i]],
                         sample.include.block2=samp.blocks[[j]])

save(out, file=paste0("intermediate/pcrelate", "_block_", i, "_", j, ".RData.gz"))

seqClose(seqData)

# mem stats
ms <- gc()
cat(">>> Max memory: ", ms[1,6]+ms[2,6], " MB\n")

###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################


kin.thresh = 2^(-13/2)
kinBtwn = out$kinBtwn[kin > kin.thresh]

pcrelobj <- list(kinSelf = out$kinSelf, kinBtwn = kinBtwn)
class(pcrelobj) <- "pcrelate"
save(pcrelobj, file=paste0(config["pcrelate_prefix"], "_pcrelate.RData"))


km <- pcrelateToMatrix(pcrelobj, thresh = 2*kin.thresh, scaleKin = 2)
