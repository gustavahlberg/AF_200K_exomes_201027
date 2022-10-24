library(GMMAT)
library(SeqVarTools)

# ---------------------------------------------
#
# load data
#

# PATH: /home/projects/cu_10039/projects/AF_200K_exomes_201027

grm_fn <- "/home/projects/cu_10039/projects/AF_200K_exomes_201027/modules/makeGRM_201102/results/pcrelate_Matrix_201113.RData"
load(grm_fn, verbose = T)


pheno_fn <- "/home/projects/cu_10039/projects/AF_200K_exomes_201027/data/phenotypes/diseasePhenos_201113.tab.gz"
cov_fn <- "/home/projects/cu_10039/projects/AF_200K_exomes_201027/data/phenotypes/covarites_201113.tab.gz"

pheno <- read.table(pheno_fn,
                    header = T)

cov <- read.table(cov_fn,
                  header = T)

samples_exomes <- as.character(read.table("/home/projects/cu_10039/projects/AF_200K_exomes_201027/data/samples200Kexomes.etn.201030.list",
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
                 disease = pheno$af,
                 ageOfOnset = pheno$AFOnset,
                 sex = cov$sex,
                 age = cov$age,
                 cov[, paste0("PC", 1:10)]
                 )

df$ageOfOnset[is.na(df$ageOfOnset)] <- df$age[is.na(df$ageOfOnset)]

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
# select snps
#


gds <- seqOpen("/home/projects/cu_10039/projects/AF_200K_exomes_201027/data/gds/ukb23156_c1_v1.filter.miss.norm.gds")

snpids <- seqGetData(gds, "annotation/id")

# find snps of interest here
snps <- snpids[1:5]

seqClose(gds)


# ---------------------------------------------
#
# glmm wald test, långsammare men du kan välja de varianter du e intrsserad av  
# och du far ut beta varden



geno_file <- "/home/projects/cu_10039/projects/AF_200K_exomes_201027/data/gds/ukb23156_c1_v1.filter.miss.norm.gds"

glmm.wald(fixed = disease ~ age + sex + PC1 + PC2 + PC3 + PC4 + PC5,
          data = df,
          kins = grm,
          id = "sample.id",
          family = binomial(link = "logit"),
          infile = geno_file,
          snps = snps,
          )


# ---------------------------------------------
#
# glmm score test, snabbare alternativ men då kör du alla.
#


# ladda din null model haer
load("../nullmodel_201202/results/model0_210213.Rdata", verbose = T)

geno_file <- "/home/projects/cu_10039/projects/AF_200K_exomes_201027/data/gds/ukb23156_c1_v1.filter.miss.norm.gds"



glmm.score(model0,
           infile = geno_file,
           outfile = "glmm.score.testoutfile.txt")





####################################
# EOF ## EOF ## EOF ## EOF ## EOF ##
####################################
# CHRISTIAN rs6795970
####################################



geno_file <- "/home/projects/cu_10039/projects/AF_200K_exomes_201027/data/gds/ukb23156_c3_v1.filter.miss.norm.gds"
gds <- seqOpen(geno_file)
snpids <- seqGetData(gds, "annotation/id")

seqSetFilter(gds, variant.id = grep("chr3_38725184_A_G", snpids))


seqGDS2BED(gds, out.fn = "rs6795970")

seqExport(gds, out.fn = "rs6795970.gds")

