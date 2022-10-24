library(HDF5Array)
library(rhdf5)
library(dplyr)
library(R.utils)
library(data.table)
library(RColorBrewer)
library(aberrant)
library(rethinking)
library(spatstat.utils)

# library("devtools")
# install_github("carbocation/aberrant")


# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# 
# BiocManager::install("HDF5Array")


PROJ_DATA="~/Projects/ManageUkbb/data/phenotypeFile/"
h5.fn <- paste(PROJ_DATA,"ukb41714.all_fields.h5", sep = '/')
sample.id = h5read(h5.fn,"sample.id")
colnames(sample.id) = "sample.id"
