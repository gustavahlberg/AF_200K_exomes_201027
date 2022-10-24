# ---------------------------------------------
#
# CAD
# 
# ---------------------------------------------

defCAD = list(f.20002 = c("1074","1075"),
              f.20004 = c("1095","1107","1523"),
              f.41270 = c("I20|I21|I22|I23|I240|I241|I250|I252"),
              f.41271 = c("4101","4102","4103","4104","4105","4106","4107","4108","4109",
                          "411","4110","4111","4118","4119",
                          "412","4129","4140","413","4139"),
              f.41272 = c("K40","K401","K402","K403","K404","K41","K411",
                          "K412","K413","K414","K45","K451","K452","K453",
                          "K454","K455","K49","K491","K492","K498","K499","K502",
                          "K75","K751","K752","K753","K754","K758","K759")
)


nSamples = dim(icdCodesList$ICD10)[1]

# ---------------------------------------------
#
# CAD
# 


CADpheno = data.frame(sample.id = rownames(icdCodesList$ICD10),
                     icd10 = rep(0, nSamples),
                     dateICD10 = rep(0, nSamples),
                     icd9 = rep(0, nSamples),
                     dateICD9 = rep(0, nSamples),
                     opcs4 = rep(0, nSamples),
                     dateOPCS4 = rep(0, nSamples),
                     illSR = rep(0, nSamples),
                     illSRage = rep(0, nSamples),
                     opSR = rep(0, nSamples),
                     opSRage = rep(0, nSamples),
                     stringsAsFactors = F
)

rownames(CADpheno) <-CADpheno$sample.id

# --------------------------------
#icd 10


table(icdCodesList$ICD10[grep(defCAD$f.41270, icdCodesList$ICD10 )])
idx = grep(defCAD$f.41270, icdCodesList$ICD10)
dates = icdCodesList$dateICD10[idx]

#add dates
names(idx) = CADpheno$sample.id[idx%%nSamples]

for(CADSample in unique(names(idx))) {
  idxCADSample = which(names(idx) == CADSample )
  CADSampleDate = as.Date(dates[idxCADSample])
  CADpheno[CADSample,]$dateICD10 <- as.character(CADSampleDate[which.min(CADSampleDate)])
}

sum(duplicated(idx%%nSamples))
idx = unique(idx%%nSamples)
CADpheno$icd10[idx] <- 1


# --------------------------------
# icd 9

idx = which(icdCodesList$ICD9 %in% defCAD$f.41271)
table(icdCodesList$ICD9[idx])

#add dates
dates = icdCodesList$dateICD9[idx]
names(idx) = CADpheno$sample.id[idx%%nSamples]

for(CADSample in unique(names(idx))) {
  idxCADSample = which(names(idx) == CADSample )
  CADSampleDate = as.Date(dates[idxCADSample])
  CADpheno[CADSample,]$dateICD9 <- as.character(CADSampleDate[which.min(CADSampleDate)])
}


idx = unique(idx%%nSamples)
CADpheno$icd9[idx] <- 1


# --------------------------------
# opcs4

table(icdCodesList$OPCS4[icdCodesList$OPCS4 %in% defCAD$f.41272])
idx = which(icdCodesList$OPCS4 %in% defCAD$f.41272)

#add dates
dates = icdCodesList$dateOPCS4[idx]
names(idx) = CADpheno$sample.id[idx%%nSamples]

for(CADSample in unique(names(idx))) {
  idxCADSample = which(names(idx) == CADSample )
  CADSampleDate = as.Date(dates[idxCADSample])
  CADpheno[CADSample,]$dateOPCS4 <- as.character(CADSampleDate[which.min(CADSampleDate)])
}



idx = unique(idx%%nSamples)
CADpheno$opcs4[idx] <- 1

CADpheno[idx,]

# --------------------------------
# self reported

idx = which(icdCodesList$illnessSelfreported %in% defCAD$f.20002)
#icdCodesList$illnessSelfreported[idx]
age = icdCodesList$ageIllnessSelfreported[idx]
names(idx) = CADpheno$sample.id[idx%%nSamples]

for(CADSample in unique(names(idx))) {
  idxCADSample = which(names(idx) == CADSample )
  CADSampleAge = age[idxCADSample]
  CADpheno[CADSample,]$illSRage <- CADSampleAge[which.min(CADSampleAge)]
}


idx = unique(idx%%nSamples)
CADpheno$illSR[idx] <- 1


# --------------------------------
# opertation self reported

idx = which(icdCodesList$opCodeSelfReported %in% defCAD$f.20004)

age = icdCodesList$ageOpCodeSelfReported[idx]
names(idx) = CADpheno$sample.id[idx%%nSamples]

for(CADSample in unique(names(idx))) {
  idxCADSample = which(names(idx) == CADSample )
  CADSampleAge = age[idxCADSample]
  CADpheno[CADSample,]$opSRage <- CADSampleAge[which.min(CADSampleAge)]
}


idx = unique(idx%%nSamples)
CADpheno$opSR[idx] <- 1

CADpheno[idx,]


# ---------------------------------------------
#
# Print
# 

CADpheno$dateOfBirth <- pheno$dateOfBirth

write.table(CADpheno,
            file = "../../data/phenotypes/CAD.tab",
            col.names = T,
            quote = F,
            row.names = F
)


# ---------------------------------------------
#
# Summary
# 

sum(rowSums(CADpheno[,c('icd10',"icd9","opcs4","illSR","opSR")]) > 0)
pheno$CAD = ifelse(rowSums(CADpheno[,c('icd10',"icd9","opcs4","illSR","opSR")]) > 0,1,0)

# based on icd
idxCADdate = which(rowSums(CADpheno[,c('icd10',"icd9","opcs4")]) > 0)

earliestDates = apply(CADpheno[idxCADdate,c("dateICD10","dateICD9", "dateOPCS4")],1, function(x){
  x = x[!x == 0]
  x[which.min(as.Date(x))]
})


CADonset <- round(time_length( difftime(earliestDates, pheno$dateOfBirth[idxCADdate]), "years"), digits = 1)

pheno$CADonset = ""
pheno[names(earliestDates),"CADonset"] <- CADonset

# based on self reported
idxCADdate = which(rowSums(CADpheno[,c('icd10',"icd9","opcs4")]) == 0 & rowSums(CADpheno[,c('illSR',"opSR")]) > 0 )

youngestAge = apply(CADpheno[idxCADdate,c("illSRage","opSRage")],1, function(x){
  x[x %in% c(-1,-3)] <- 150
  x = x[!x == 0]
  if(length(x) < 1) {
    x = 0
  }
  x[which.min(x)]
})

youngestAge[youngestAge == 150] <- NA
pheno[names(youngestAge),"CADonset"] <- youngestAge

summary(as.numeric(pheno$CADonset), na.rm = T)





#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################

