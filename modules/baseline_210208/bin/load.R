library(HDF5Array)
library(rhdf5)
library(dplyr)
library(R.utils)
library(data.table)
library(RColorBrewer)
#library(aberrant)
library(rethinking)
library(spatstat.utils)
library(lubridate)


<<<<<<< HEAD

PROJ_DATA="~/Projects_2/ManageUkbb/data/phenotypeFile"
PROJ_DATA="/home/projects/cu_10039/data/UKBB/phenotypeFn"
h5.fn <- paste(PROJ_DATA,"ukb41714.all_fields.h5", sep = '/')
=======
PROJ_DATA="~/Projects/ManageUkbb/data/phenotypeFile"
h5.fn <- paste(PROJ_DATA,"ukb45051.all_fields.h5", sep = '/')
>>>>>>> d04a1d54a178808ee7c88251d8e4dd098e0097e9
sample.id = h5read(h5.fn,"sample.id")
colnames(sample.id) = "sample.id"

h5readAttributes(h5.fn, "f.20009")



# --------------------
# eth matched

sample.eth.id <- as.character(read.table("../../data/samplesUKBB.etn.201030.list")$V1)

# --------------------
# eth matched exomes


sample.eth.exo.id <- as.character(read.table("../../data/samples200Kexomes.etn.201030.list")$V1)


# --------------------
# withdrawls

withdralws.id <- as.character(read.table("../../../ManageUkbb/data/withdrawls/w43247_20210201.csv")$V1)


# --------------------
# rm withdrawls


sample.eth.id <- sample.eth.id[!sample.eth.id %in% withdralws.id]
sample.eth.exo.id <- sample.eth.exo.id[!sample.eth.exo.id %in% withdralws.id]


#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################

#install.packages("remotes")
#remotes::install_github("stan-dev/rstan", ref = "develop", subdir = "rstan/rstan")

