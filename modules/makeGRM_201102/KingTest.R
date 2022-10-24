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

samp.id <- as.character(seqGetData(gds, "sample.id"))
sampleSubset = samp.id[1:1000]
seqSetFilter(gds, sample.id = sampleSubset)

# --------------------------------------------------------
#
# LD prune
#

snpset <- snpgdsLDpruning(gds,
                          method="corr", 
                          slide.max.bp=10e6,
                          ld.threshold=sqrt(0.1),
                          num.thread = 20,
                          sample.id = sampleSubset)

pruned <- unlist(snpset, use.names=FALSE)

# --------------------------------------------------------
#
# Run king
#



king <- snpgdsIBDKING(gds, type = "KING-robust",
                      sample.id = sampleSubset,
                      snp.id=pruned, num.thread = 20,
                      useMatrix = T, verbose = T)

#snpgdsClose(gds)
print("King done")



# --------------------------------------------------------
#
# Save king
#

date =  format(Sys.time(), "%y%m%d")
save(file = paste0("results/kingrobustTest_", date,".rda.gz"),
     king,
     compress = TRUE)



#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################
