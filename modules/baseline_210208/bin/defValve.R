# old def.
# defValve = list(f.20002 = c("1490","1586","1587", 
#                             "1584","1489","1488", "1585"),
#                 f.20004 = c("1100","1099"),
#                 f.41270 = c("I06","I080","I081","I082","I083","I390","I391","I393","I05","I34",
#                             "I07","I36","I37"),
#                 f.41271 = c("3951","3959","4241","3940", "3942","3949","4240", "4243"),
#                 f.41272 = c("K26","K302","K25", "K301","K341", "K351",
#                             "K27","K303","K28", "K304", "K357")
# )
# ---------------------------------------------
#
# Valve
# 



defValve = list(f.20002 = c("1490","1586","1587", 
                            "1584","1489","1488", "1585"),
                f.20004 = c("1100","1099"),
                f.41270 = c("I01","I018","I019","I020","I05","I050","I051","I052","I058","I059",
                            "I06","I060","I061","I062","I068","I069","I07","I070","I071",
                            "I072","I078","I079","I080","I081","I081","I081","I082",
                            "I082","I082","I083","I088","I089","I09","I091","I098",
                            "I099","I34","I340","I340","I341","I341","I342","I348",
                            "I349","I35","I351","I352","I358","I359","I359","I36",
                            "I360","I361","I362","I368","I369","I37","I370",
                            "I371","I372","I379","I39"),
                f.41271 = c("394","3949","395","3959","396","3969","3970","3971",
                            "4240","4241","4242","4243","3940","3941","3942","3950",
                            "3951","3952"),
                f.41272 = c("K26","K302","K25", "K301","K341", "K351",
                            "K27","K303","K28", "K304", "K357")
                )



all(rownames(icdCodesList$ICD10) == allTab$ID_1)
nSamples = dim(icdCodesList$ICD10)[1]


# ---------------------------------------------
#
# Valve
# 


VALVEpheno = data.frame(sample.id = rownames(icdCodesList$ICD10),
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

rownames(VALVEpheno) <-VALVEpheno$sample.id

# --------------------------------
#icd 10

idx = which(icdCodesList$ICD10 %in% defValve$f.41270)
sort(table(icdCodesList$ICD10[idx]))
sum(table(icdCodesList$ICD10[idx]))

dates = icdCodesList$dateICD10[idx]

#add dates
names(idx) = VALVEpheno$sample.id[idx%%nSamples]

for(VALVESample in unique(names(idx))) {
  idxVALVESample = which(names(idx) == VALVESample )
  VALVESampleDate = as.Date(dates[idxVALVESample])
  VALVEpheno[VALVESample,]$dateICD10 <- as.character(VALVESampleDate[which.min(VALVESampleDate)])
}

sum(duplicated(idx%%nSamples))
idx = unique(idx%%nSamples)
VALVEpheno$icd10[idx] <- 1


# --------------------------------
# icd 9

idx = which(icdCodesList$ICD9 %in% defValve$f.41271)
table(icdCodesList$ICD9[idx])

#add dates
dates = icdCodesList$dateICD9[idx]
names(idx) = VALVEpheno$sample.id[idx%%nSamples]

for(VALVESample in unique(names(idx))) {
  idxVALVESample = which(names(idx) == VALVESample )
  VALVESampleDate = as.Date(dates[idxVALVESample])
  VALVEpheno[VALVESample,]$dateICD9 <- as.character(VALVESampleDate[which.min(VALVESampleDate)])
}


idx = unique(idx%%nSamples)
VALVEpheno$icd9[idx] <- 1


# --------------------------------
# opcs4

table(icdCodesList$OPCS4[icdCodesList$OPCS4 %in% defValve$f.41272])
idx = which(icdCodesList$OPCS4 %in% defValve$f.41272)

#add dates
dates = icdCodesList$dateOPCS4[idx]
names(idx) = VALVEpheno$sample.id[idx%%nSamples]

for(VALVESample in unique(names(idx))) {
  idxVALVESample = which(names(idx) == VALVESample )
  VALVESampleDate = as.Date(dates[idxVALVESample])
  VALVEpheno[VALVESample,]$dateOPCS4 <- as.character(VALVESampleDate[which.min(VALVESampleDate)])
}



idx = unique(idx%%nSamples)
VALVEpheno$opcs4[idx] <- 1

VALVEpheno[idx,]

# --------------------------------
# self reported

idx = which(icdCodesList$illnessSelfreported %in% defValve$f.20002)
#icdCodesList$illnessSelfreported[idx]
age = icdCodesList$ageIllnessSelfreported[idx]
names(idx) = VALVEpheno$sample.id[idx%%nSamples]

for(VALVESample in unique(names(idx))) {
  idxVALVESample = which(names(idx) == VALVESample )
  VALVESampleAge = age[idxVALVESample]
  VALVEpheno[VALVESample,]$illSRage <- VALVESampleAge[which.min(VALVESampleAge)]
}


idx = unique(idx%%nSamples)
VALVEpheno$illSR[idx] <- 1


# --------------------------------
# opertation self reported

idx = which(icdCodesList$opCodeSelfReported %in% defValve$f.20004)

age = icdCodesList$ageOpCodeSelfReported[idx]
names(idx) = VALVEpheno$sample.id[idx%%nSamples]

for(VALVESample in unique(names(idx))) {
  idxVALVESample = which(names(idx) == VALVESample )
  VALVESampleAge = age[idxVALVESample]
  VALVEpheno[VALVESample,]$opSRage <- VALVESampleAge[which.min(VALVESampleAge)]
}


idx = unique(idx%%nSamples)
VALVEpheno$opSR[idx] <- 1

VALVEpheno[idx,]


# ---------------------------------------------
#
# Print
# 

VALVEpheno$dateOfBirth <- pheno$dateOfBirth

write.table(VALVEpheno,
            file = "../../data/phenotypes/VALVE.tab",
            col.names = T,
            quote = F,
            row.names = F
)


# ---------------------------------------------
#
# Summary
# 

sum(rowSums(VALVEpheno[,c('icd10',"icd9","opcs4","illSR","opSR")]) > 0)
pheno$VALVE = ifelse(rowSums(VALVEpheno[,c('icd10',"icd9","opcs4","illSR","opSR")]) > 0,1,0)

# based on icd
idxVALVEdate = which(rowSums(VALVEpheno[,c('icd10',"icd9","opcs4")]) > 0)

earliestDates = apply(VALVEpheno[idxVALVEdate,c("dateICD10","dateICD9", "dateOPCS4")],1, function(x){
  x = x[!x == 0]
  x[which.min(as.Date(x))]
})


VALVEonset <- round(time_length( difftime(earliestDates, pheno$dateOfBirth[idxVALVEdate]), "years"), digits = 1)

pheno$VALVEonset = ""
pheno[names(earliestDates),"VALVEonset"] <- VALVEonset

# based on self reported
idxVALVEdate = which(rowSums(VALVEpheno[,c('icd10',"icd9","opcs4")]) == 0 & rowSums(VALVEpheno[,c('illSR',"opSR")]) > 0 )

youngestAge = apply(VALVEpheno[idxVALVEdate,c("illSRage","opSRage")],1, function(x){
  x[x %in% c(-1,-3)] <- 150
  x = x[!x == 0]
  if(length(x) < 1) {
    x = 0
  }
  x[which.min(x)]
})

youngestAge[youngestAge == 150] <- NA
pheno[names(youngestAge),"VALVEonset"] <- youngestAge

summary(as.numeric(pheno$VALVEonset), na.rm = T)



#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################




