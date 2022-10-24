#
# User UKB def. of AF
# 
# ---------------------------------------------
#
# AF
# 

I48pheno = data.frame(sample.id = rownames(icdCodesList$ICD10),
                      i48 = rep(0, nSamples),
                      death_reg_only = rep(0, nSamples),
                      death_reg_other = rep(0, nSamples),
                      primary_care_only = rep(0, nSamples),
                      primary_care_other = rep(0, nSamples),
                      hospital_admissions_only = rep(0, nSamples),
                      hospital_admission_other = rep(0, nSamples),
                      self_report_only = rep(0, nSamples),
                      self_report_other = rep(0, nSamples),
                      dateOfOnsetI48 = rep(0, nSamples),
                      ageOfI48 = rep(0, nSamples),
                      stringsAsFactors = F
)

# ---------------------------------
# I48


h5readAttributes(h5.fn,"f.131351")
h5readAttributes(h5.fn,"f.131351/f.131351")$f.131351

f131351 <- h5read(h5.fn,"f.131351/f.131351")
f131351[f131351 == -9999,] <- 0
i48 <- f131351
i48[i48 != 0,] <- 1
rownames(i48) <- sample.id
rownames(f131351) <- sample.id

i48 <- i48[sample.eth.id,]
f131351 <- f131351[sample.eth.id,]


# ---------------------------------
# age


h5readAttributes(h5.fn,"f.131350")
dateI48 <- h5read(h5.fn,"f.131350/f.131350")
dateI48[dateI48 == -9999] <- NA
rownames(dateI48) <- sample.id

ageOfOnset <- round(time_length( difftime(dateI48[sample.eth.id,], 
                                          pheno$dateOfBirth), "years"), 
                    digits = 1)

ageLatestUp <- round(time_length(difftime(max(dateI48[sample.eth.id,],na.rm = T),
                     pheno$dateOfBirth),"years"),
                digits = 1)

ageOfOnset[which(is.na(ageOfOnset))] <- ageLatestUp[which(is.na(ageOfOnset))]

ageOfOnset[which(dateI48[sample.eth.id,] %in% c("1900-01-01", "1902-02-02","1903-03-03",
                                               "2037-07-07"))] <- NA

dateI48[sample.eth.id,][ageOfOnset <0 ]
hist(ageOfOnset, breaks = 100)
ageOfOnset[ageOfOnset < 20]


# ---------------------------------
# put in df.

I48pheno$dateOfOnsetI48 <- dateI48[sample.eth.id,]
I48pheno$ageOfI48 <- ageOfOnset
I48pheno$i48 <- i48

I48pheno$death_reg_only[f131351 == 20] <- 1
I48pheno$death_reg_other[f131351 == 21] <- 1
I48pheno$primary_care_only[f131351 == 30] <- 1
I48pheno$primary_care_other[f131351 == 31] <- 1
I48pheno$hospital_admissions_only[f131351 == 40] <- 1
I48pheno$hospital_admission_other[f131351 == 41] <- 1
I48pheno$self_report_only[f131351 == 50] <- 1
I48pheno$self_report_other[f131351 == 51] <- 1


sum(I48pheno$ageOfI48 < 60 & I48pheno$i48 == 1,na.rm = T)
colSums(I48pheno[,-c(1,11,12)])

# ---------------------------------------------
#
# Print
# 


write.table(I48pheno,
            file = "../../data/phenotypes/I48.tab",
            col.names = T,
            quote = F,
            row.names = F
)

# pheno <- read.table("../../data/phenotypes/diseasePhenos_201113.tab.gz", 
#                     header = T)
# rownames(pheno) <- pheno$sample.id
# pheno <- pheno[!pheno$sample.id %in% withdralws.id,]

all(rownames(pheno) == I48pheno$sample.id)

pheno$I48 = I48pheno$i48
pheno$ageOfI48 <- ageOfOnset


#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################
