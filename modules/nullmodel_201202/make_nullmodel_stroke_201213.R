#
# Make null model
#
# ---------------------------------------------
#
# Set relative path an source enviroment
#

rm(list = ls())
set.seed(100)
DIR <- system(intern = TRUE, ignore.stderr = TRUE,
           "cd \"$( dirname \"${BASH_SOURCE[0]}\" )\" && pwd ")

#library(SeqVarTools)
library(GMMAT)
date <- format(Sys.time(), "%y%m%d")


# ---------------------------------------------
#
# load data
#
# GRM

grm_fn <- "../makeGRM_201102/results/pcrelate_Matrix_201113.RData"
load(grm_fn, verbose = T)
#grm <- as.matrix(read.table(G, check.names = FALSE))


# Pheno

pheno_fn <- "../../data/phenotypes/diseasePhenos_201113.tab.gz"
cov_fn <- "../../data/phenotypes/covarites_201113.tab.gz"

pheno <- read.table(pheno_fn,
                    header = T)

cov <- read.table(cov_fn,
                  header = T)

samples_exomes <- as.character(read.table("../../data/samples200Kexomes.etn.201030.list",
                                         header = F)$V1)


# rm withdrawls
withdrawls <- as.character(
    read.table("/home/projects/cu_10039/data/UKBB/withdrawls/w43247_20210201.csv",
               header = F)$V1)

samples_exomes <- samples_exomes[!samples_exomes %in% withdrawls]


# ---------------------------------------------
#
# make df
#

all(cov$sample.id == pheno$sample.id)

df <- data.frame(sample.id = pheno$sample.id,
                 af = pheno$af,
                 afOnset = pheno$AFOnset,
                 stroke = pheno$stroke,
                 strokeOnset = pheno$ageOfStroke,
                 ischStroke = pheno$ischStroke,
                 ischStrokeOnset = pheno$ageAtIschStroke,
                 sex = cov$sex,
                 age = cov$age,
                 cov[, paste0("PC", 1:10)]
                 )

df$afOnset[is.na(df$afOnset)] <- df$age[is.na(df$afOnset)]

df$strokeOnset[is.na(df$strokeOnset)] <- df$age[is.na(df$strokeOnset)]
df$ischStrokeOnset[is.na(df$ischStrokeOnset)] <- df$age[is.na(df$ischStrokeOnset)]

df$ces <- ifelse(df$ischStroke == 1 & df$af == 1, 1, 0)
df$cesOnset <- df$ischStrokeOnset


df <- df[df$sample.id %in% samples_exomes, ]

# ---------------------------------------------
#
# rm sex NA
#

df <- df[!is.na(df$sex), ]
df$sample.id <- as.character(df$sample.id)

grm <- km[df$sample.id, df$sample.id]


# ---------------------------------------------
#
# stroke
#

model0 <- glmmkin(stroke ~ age + sex + PC1 + PC2 + PC3 + PC4,
                  data = df,
                  kins = grm,
                  id = "sample.id",
                  method.optim = "AI",
                  maxiter = 4000,
                  family = binomial(link = "logit"))


model0_fn <- paste0("model0_stroke", date, ".Rdata")
save(model0, file = model0_fn)

model0_ageonset <- glmmkin(stroke ~ strokeOnset + sex + PC1 + PC2 + PC3 + PC4,
                           data = df,
                           kins = grm,
                           id = "sample.id",
                           method.optim = "AI",
                           maxiter = 4000,
                           family = binomial(link = "logit"))



model0_ageonset_fn <- paste0("model0_ageonset_stroke", date, ".Rdata")
save(model0_ageonset, file = model0_ageonset_fn)


# ---------------------------------------------
#
# ischemic stroke
#

model0 <- glmmkin(ischStroke ~ age + sex + PC1 + PC2 + PC3 + PC4,
                  data = df,
                  kins = grm,
                  id = "sample.id",
                  method.optim = "AI",
                  maxiter = 4000,
                  family = binomial(link = "logit"))


model0_fn <- paste0("model0_ischStroke", date, ".Rdata")
save(model0, file = model0_fn)

model0_ageonset <- glmmkin(ischStroke ~ ischStrokeOnset + sex + PC1 + PC2 + PC3 + PC4,
                           data = df,
                           kins = grm,
                           id = "sample.id",
                           method.optim = "AI",
                           maxiter = 4000,
                           family = binomial(link = "logit"))



model0_ageonset_fn <- paste0("model0_ageonset_ischStroke", date, ".Rdata")
save(model0_ageonset, file = model0_ageonset_fn)



# ---------------------------------------------
#
# ces
#

# rm other stroke
df <- df[which(df$stroke == 1 & df$ces == 0 ), ]
grm <- km[df$sample.id, df$sample.id]


model0 <- glmmkin(ces ~ age + sex + PC1 + PC2 + PC3 + PC4,
                  data = df,
                  kins = grm,
                  id = "sample.id",
                  method.optim = "AI",
                  maxiter = 4000,
                  family = binomial(link = "logit"))


model0_fn <- paste0("model0_ces", date, ".Rdata")
save(model0, file = model0_fn)

model0_ageonset <- glmmkin(ces ~ cesOnset + sex + PC1 + PC2 + PC3 + PC4,
                           data = df,
                           kins = grm,
                           id = "sample.id",
                           method.optim = "AI",
                           maxiter = 4000,
                           family = binomial(link = "logit"))



model0_ageonset_fn <- paste0("model0_ageonset_ces", date, ".Rdata")
save(model0_ageonset, file = model0_ageonset_fn)



###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################





