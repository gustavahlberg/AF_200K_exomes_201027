#
#
# Module for extracting phenotypes and covars
# in AF 200 exomes project
#
# ---------------------------------------------
#
# Set relative path an source enviroment
#

rm(list= ls())
set.seed(42)
DIR=system(intern=TRUE,ignore.stderr = TRUE,
           "cd \"$( dirname \"${BASH_SOURCE[0]}\" )\" && pwd ")






# ---------------------------------------------
#
# load
#

load("bin/load.R")

# ---------------------------------------------
#
# icd.R
#


source("bin/icd.R")
source("bin/icd_test.R")


# ---------------------------------------------
#
# Phenotypes
#


source("bin/defPhenos.R")


# ---------------------------------------------
#
# covarites 
#


source("bin/cov.R")


# ---------------------------------------------
#
# baseline table
#


source("bin/baseLineTable.R")


#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################
