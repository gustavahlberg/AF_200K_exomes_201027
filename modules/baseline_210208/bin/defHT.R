# ---------------------------------------------
#
# HT
# 
# ---------------------------------------------

defHT = list(f.20002 = c("1065","1072"),
             f.41270 = c("I10","I11","I110","I119","I12","I120","I129",
                         "I13","I130","I131","I132","I139","I15","I150","I151",
                         "I152","I158","I159"),
             f.41271 = c("401","4010","4011","4019","402","4020","4021","4029","403","4030",
                         "4031","4039","404","4040","4041","4049","405","4050","4051","4059")
)


# ---------------------------------------------
#
# HT
# 


HTpheno = data.frame(sample.id = rownames(icdCodesList$ICD10),
                      icd10 = rep(0, nSamples),
                      dateICD10 = rep(0, nSamples),
                      icd9 = rep(0, nSamples),
                      dateICD9 = rep(0, nSamples),
                      illSR = rep(0, nSamples),
                      illSRage = rep(0, nSamples),
                      stringsAsFactors = F
)

rownames(HTpheno) <-HTpheno$sample.id

# --------------------------------
#icd 10


idx = which(icdCodesList$ICD10 %in% defHT$f.41270)
table(icdCodesList$ICD10[idx])
dates = icdCodesList$dateICD10[idx]

#add dates
names(idx) = HTpheno$sample.id[idx%%nSamples]

for(HTSample in unique(names(idx))) {
  idxHTSample = which(names(idx) == HTSample )
  HTSampleDate = as.Date(dates[idxHTSample])
  HTpheno[HTSample,]$dateICD10 <- as.character(HTSampleDate[which.min(HTSampleDate)])
}

sum(duplicated(idx%%nSamples))
idx = unique(idx%%nSamples)
HTpheno$icd10[idx] <- 1


# --------------------------------
# icd 9

idx = which(icdCodesList$ICD9 %in% defHT$f.41271)
table(icdCodesList$ICD9[idx])

#add dates
dates = icdCodesList$dateICD9[idx]
names(idx) = HTpheno$sample.id[idx%%nSamples]

for(HTSample in unique(names(idx))) {
  idxHTSample = which(names(idx) == HTSample )
  HTSampleDate = as.Date(dates[idxHTSample])
  HTpheno[HTSample,]$dateICD9 <- as.character(HTSampleDate[which.min(HTSampleDate)])
}


idx = unique(idx%%nSamples)
HTpheno$icd9[idx] <- 1



# --------------------------------
# self reported


idx = which(icdCodesList$illnessSelfreported %in% defHT$f.20002)
table(icdCodesList$illnessSelfreported[idx])
age = icdCodesList$ageIllnessSelfreported[idx]
names(idx) = HTpheno$sample.id[idx%%nSamples]

for(HTSample in unique(names(idx))) {
  idxHTSample = which(names(idx) == HTSample)
  HTSampleAge = age[idxHTSample]
  HTpheno[HTSample,]$illSRage <- HTSampleAge[which.min(HTSampleAge)]
}


idx = unique(idx%%nSamples)
HTpheno$illSR[idx] <- 1


# ---------------------------------------------
#
# Print
# 

HTpheno$dateOfBirth <- pheno$dateOfBirth

write.table(HTpheno,
            file = "../../data/phenotypes/HT.tab",
            col.names = T,
            quote = F,
            row.names = F
)


# ---------------------------------------------
#
# Summary
# 

sum(rowSums(HTpheno[,c('icd10',"icd9","illSR")]) > 0)
pheno$HT = ifelse(rowSums(HTpheno[,c('icd10',"icd9","illSR")]) > 0,1,0)

# based on icd
idxHTdate = which(rowSums(HTpheno[,c('icd10',"icd9")]) > 0)

earliestDates = apply(HTpheno[idxHTdate,c("dateICD10","dateICD9")],1, function(x){
  x = x[!x == 0]
  x[which.min(as.Date(x))]
})


HTonset <- round(time_length(difftime(earliestDates, pheno$dateOfBirth[idxHTdate]), "years"), digits = 1)

pheno$HTonset = ""
pheno[names(earliestDates),"HTonset"] <- HTonset


# HT dates based on self reported
idxHTdate = which(rowSums(HTpheno[,c('icd10',"icd9")]) == 0 & (HTpheno[,c('illSR')] > 0) )
pheno[idxHTdate, "HTonset"] <- HTpheno[idxHTdate,c("illSRage")]
pheno$HTonset[pheno[,"HTonset"] %in% c(-1,-3,-9999)] <- NA


summary(as.numeric(pheno$HTonset), na.rm = T)



#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################
