#
# Run king robust 
#
# --------------------------------------------------------
#
# load
#

gdsfile="../../data/ukbSubset.filtered.gds"
library(SeqArray)
library(SNPRelate)
set.seed(100)

gds <- seqOpen(gdsfile)



# --------------------------------------------------------
#
# LD prune
#

## snpset <- snpgdsLDpruning(gds,
##                           method="corr", 
##                           slide.max.bp=10e6,
##                           ld.threshold=sqrt(0.1),
##                           num.thread = 20)

## pruned <- unlist(snpset, use.names=FALSE)

load("results/pruned_201105.rda.gz", verbose = T)


# --------------------------------------------------------
#
# Run king
#



king <- snpgdsIBDKING(gds, type = "KING-robust",
                      snp.id=pruned, num.thread = 20,
                      verbose = T)

#snpgdsClose(gds)
print("King done")



# --------------------------------------------------------
#
# Save king
#

date = format(Sys.time(), "%y%m%d")
save(file = paste0("results/kingrobust_", date,".rda.gz"),
     king,
     compress = TRUE)

## save(file = paste0("results/pruned_", date,".rda.gz"),
##      pruned,
##      compress = TRUE)


#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################
