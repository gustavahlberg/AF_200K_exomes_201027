#
# Module for defining list of etnhically matched and
# unrelated samples
#
# ---------------------------------------------
#
# Set relative path an source enviroment
#


rm(list= ls())
set.seed(42)
DIR=system(intern=TRUE,ignore.stderr = TRUE,
           "cd \"$( dirname \"${BASH_SOURCE[0]}\" )\" && pwd ")

source("load.R")

# ---------------------------------------------
#
# load qc tables
#


source("loadQCtable.R")


# ---------------------------------------------
#
# ethnicity
#

#source("ethnicity.R")
source("ethnicity_norerun.R")
read.table("results/samplesUKBB.etn.201030.list")$V1
dfCohort = dfW[dfW$eur_select == 1,]
sample.eth.id <- dfCohort$sample.id
sample.eth.id = sample.id[sample.id %in% sample.eth.id]

source("ethnicityAFR.R")
source("ethnicityAS.R")

length(sample.eth.id)
length(read.table("results/samplesUKBB.etn.201030.list")$V1)
sum(sample.eth.id %in% read.table("results/samplesUKBB.etn.201030.list")$V1)

# ---------------------------------------------
#
# Plot ethnicity
#


source("plotEthnicity.R")


# ---------------------------------------------
#
# icd.R
#


source("icd.R")


# ---------------------------------------------
#
# define AF
#


source("defineAF.R")


# ---------------------------------------------
#
# print results
#

source("printResults.R")




# ---------------------------------------------
#
# rm related w/ priortizing AF defined samples
# AFpheno.etn


#source("relatedness.R")


#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################
