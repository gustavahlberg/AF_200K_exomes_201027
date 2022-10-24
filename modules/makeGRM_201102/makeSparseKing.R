#
# make sparse King mat
#
# --------------------------------------------------------
#
# load
#


library(GENESIS)
load("results/kingrobust_201108.rda.gz", verbose = T)
gdsfile="results/kingRobustMat.gds"
date = format(Sys.time(), "%y%m%d")
sample.king.id <- king$sample.id
# --------------------------------------------------------
#
# king sparse mat
#
# makeSparseMatrix


## print("making sparse matrix")
## #kingSparse = kingToMatrix(king, thresh = 2^(-11/2), verbose = TRUE)
## makeSparseMatrix(king, thresh = 2^(-11/2),
##                  verbose = TRUE)

## save(file = paste0("results/kingSparse", date, "rda.gz"),
##      kingSparse,
##      compress = TRUE)

## print("sparse matrix done")
## rm(kingSparse)


# --------------------------------------------------------
#
# make kingmat gds
#
# 

print("making king gds")
king = king$kinship
colnames(king) <- rownames(king) <- sample.king.id
mat2gds(king, gdsfile)
print("king gds done")

# --------------------------------------------------------
#
# save
#

## print("saving king mat")
## save(file = paste0("results/kingMat", date, "rda.gz"),
##      king,
##      compress = TRUE)
## print("saving king mat done")



#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################
