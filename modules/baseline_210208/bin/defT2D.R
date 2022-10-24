#
# define T2D
# 
# ---------------------------------------------
#
# df
#

defT2D = list(f.20002 = c("1223"),
              f.41270 = c("E11"),
              f.41271 = c("25000","25002"),
              exclude = c(0,0,0)
)


nSamples = dim(icdCodesList$ICD10)[1]


# ---------------------------------------------
#
# T2D
# 


T2Dpheno = data.frame(sample.id = rownames(icdCodesList$ICD10),
                     icd10 = rep(0, nSamples),
                     dateICD10 = rep(0, nSamples),
                     icd9 = rep(0, nSamples),
                     dateICD9 = rep(0, nSamples),
                     illSR = rep(0, nSamples),
                     illSRage = rep(0, nSamples),
                     stringsAsFactors = F
)

rownames(T2Dpheno) <-T2Dpheno$sample.id

# --------------------------------
#icd 10

table(icdCodesList$ICD10[grep(defT2D$f.41270, icdCodesList$ICD10)])
idx = grep(defT2D$f.41270, icdCodesList$ICD10)
dates = icdCodesList$dateICD10[idx]

#add dates
names(idx) = T2Dpheno$sample.id[idx%%nSamples]

for(T2DSample in unique(names(idx))) {
  idxT2DSample = which(names(idx) == T2DSample )
  T2DSampleDate = as.Date(dates[idxT2DSample])
  T2Dpheno[T2DSample,]$dateICD10 <- as.character(T2DSampleDate[which.min(T2DSampleDate)])
}

sum(duplicated(idx%%nSamples))
idx = unique(idx%%nSamples)
T2Dpheno$icd10[idx] <- 1


# --------------------------------
# icd 9


grep(defT2D$f.41271[1], icdCodesList$ICD9)
idx = which(icdCodesList$ICD9 %in% defT2D$f.41271)
#add dates
dates = icdCodesList$dateICD9[idx]
names(idx) = T2Dpheno$sample.id[idx%%nSamples]

for(T2DSample in unique(names(idx))) {
  idxT2DSample = which(names(idx) == T2DSample )
  T2DSampleDate = as.Date(dates[idxT2DSample])
  T2Dpheno[T2DSample,]$dateICD9 <- as.character(T2DSampleDate[which.min(T2DSampleDate)])
}

idx = unique(idx%%nSamples)
T2Dpheno$icd9[idx] <- 1


# --------------------------------
# self reported

idx = which(icdCodesList$illnessSelfreported %in% defT2D$f.20002)
age = icdCodesList$ageIllnessSelfreported[idx]
names(idx) = T2Dpheno$sample.id[idx%%nSamples]

for(T2DSample in unique(names(idx))) {
  idxT2DSample = which(names(idx) == T2DSample )
  T2DSampleAge = age[idxT2DSample]
  T2Dpheno[T2DSample,]$illSRage <- T2DSampleAge[which.min(T2DSampleAge)]
}


idx = unique(idx%%nSamples)
T2Dpheno$illSR[idx] <- 1


# ---------------------------------------------
#
# Print
# 

T2Dpheno$dateOfBirth <- pheno$dateOfBirth

write.table(T2Dpheno,
            file = "../../data/phenotypes/T2D.tab",
            col.names = T,
            quote = F,
            row.names = F
)


# ---------------------------------------------
#
# Summary
# 

sum(rowSums(T2Dpheno[,c('icd10',"icd9","illSR")]) > 0)
pheno$t2d = ifelse(rowSums(T2Dpheno[,c('icd10',"icd9","illSR")]) > 0,1,0)

# based on icd
idxT2Ddate = which(rowSums(T2Dpheno[,c('icd10',"icd9")]) > 0)

# T2D icd dates
earliestDates = apply(T2Dpheno[idxT2Ddate,c("dateICD10","dateICD9")],1, function(x){
  x = x[!x == 0]
  x[which.min(as.Date(x))]
})

ageOfOnset <- round(time_length( difftime(earliestDates, pheno$dateOfBirth[idxT2Ddate]), "years"), digits = 1)
pheno$T2Donset = ""
pheno[names(earliestDates),"T2Donset"] <- ageOfOnset

# T2D dates based on self reported
idxT2Ddate = which(rowSums(T2Dpheno[,c('icd10',"icd9")]) == 0 & (T2Dpheno[,c('illSR')] > 0) )
pheno[idxT2Ddate, "T2Donset"] <- T2Dpheno[idxT2Ddate,c("illSRage")]
pheno$T2Donset[pheno[,"T2Donset"] %in% c(-1,-3,-9999)] <- NA



#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################




