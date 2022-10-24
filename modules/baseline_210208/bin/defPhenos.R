#
# define Phenotypes
# 
# ---------------------------------------------
#
# Pheno tab
#

pheno = data.frame(sample.id = rownames(icdCodesList$ICD10))
rownames(pheno) <- pheno$sample.id


# ---------------------------------------------
#
# Year of birth
#

h5readAttributes(h5.fn,"f.34")
YofBirth = h5read(h5.fn,"f.34/f.34")

h5readAttributes(h5.fn,"f.52")
MofBirth = h5read(h5.fn,"f.52/f.52")
dateOfBirth = as.Date(paste(YofBirth, MofBirth, "01", sep = "-"),
                         format = "%Y-%m-%d")
names(dateOfBirth) <- sample.id

pheno$dateOfBirth = dateOfBirth[pheno$sample.id]


# ---------------------------------------------
#
# def AF
#

source("bin/defAF.R")
#source("bin/defAF_ellinor.R")
source("bin/defI48.R")


# ---------------------------------------------
#
# def HF
#

source("bin/defHF.R")


# ---------------------------------------------
#
# Type 2 Diabetes
#

source("bin/defT2D.R")


# ---------------------------------------------
#
# CAD
#


source("bin/defCAD.R")


# ---------------------------------------------
#
# Hypertension
#


source("bin/defHT.R")


# ---------------------------------------------
#
# Valve disease
#


source("bin/defValve.R")

# ---------------------------------------------
#
# def Stroke
#

source("bin/defStroke.R")

# ---------------------------------------------
#
# MI
#


source("bin/defMI.R")


# ---------------------------------------------
#
# Print phenos
#



date = format(Sys.time(), "%y%m%d")
write.table(pheno,
            file = paste0("../../data/phenotypes/diseasePhenos_",date,".tab"),
            col.names = T,
            quote = T,
            row.names = F,
            sep = "\t"
)

rm(icdCodesList)
rm(icdCodesList_test)

#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################
