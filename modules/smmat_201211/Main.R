#
# Grouping variants
#
# ---------------------------------------------
#
# Set relative path an source enviroment
#

rm(list = ls())
set.seed(100)
DIR <- system(intern = TRUE, ignore.stderr = TRUE,
           "cd \"$( dirname \"${BASH_SOURCE[0]}\" )\" && pwd ")


library(GMMAT)

args <- commandArgs(trailingOnly = TRUE)
print(args)
chr <- args[1]
cores <- as.numeric(args[2])
test <- args[3]


# ---------------------------------------------
#
# load null model & set out
#



# load("../nullmodel_201202/results/model0_210213.Rdata", verbose = T)
load("../nullmodel_201202/results/model0_I48_ageonset210226.Rdata", verbose = T)
model0 <- model0_ageonset     
outPath <- "results_I48_ageofonset"


#load("../nullmodel_201202/results/model0_hf201213.Rdata", verbose = T)
#outPath <- "results_hf"


# ---------------------------------------------
#
# Burden LOF
#


if (test == "lof") {
    source("burdenLOF.R")
}


if (test == "lof_w") {
    source("burdenLOF_w.R")
}

if (test == "lof_smmat") {
    source("burdenLOF_smmat.R")
}


# source("burdenLOF_skat.R")

# ---------------------------------------------
#
# Burden missense
#


if (test == "missense") {
    source("burden_missense.R")
}


if (test == "missense_w") {
    source("burden_w_missense.R")
}


if (test == "missense_smmat") {
    source("burden_smmat_missense.R")
}


if (test == "missense_skat") {
    source("burden_skat_missense.R")
}


if (test == "missense_skat_w") {
    source("burden_w_skat_missense.R")
}




###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################
