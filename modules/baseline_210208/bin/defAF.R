#
# define AF
# 
# ---------------------------------------------
#
# df
#

defAF = list(f.20002 = c(1471, 1483),
             f.20004 = c(1524),
             f.41270 = c("I48"),
             f.41271 = c("4273"),
             f.41272 = c("K571", "K621", "K622", "K623", "K624","X501","X502"),
             exclude = c(0,0,0,0,0)
)



nSamples = dim(icdCodesList$ICD10)[1]


# ---------------------------------------------
#
# AF
# 


AFpheno = data.frame(sample.id = rownames(icdCodesList$ICD10),
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

rownames(AFpheno) <-AFpheno$sample.id

# --------------------------------
#icd 10


table(icdCodesList$ICD10[grep(defAF$f.41270, icdCodesList$ICD10 )])
#idx = which(icdCodesList$ICD10 %in% defAF$f.41270)
idx = grep(defAF$f.41270, icdCodesList$ICD10)
dates = icdCodesList$dateICD10[idx]

#add dates
names(idx) = AFpheno$sample.id[idx%%nSamples]

for(afSample in unique(names(idx))) {
  idxAfSample = which(names(idx) == afSample )
  afSampleDate = as.Date(dates[idxAfSample])
  AFpheno[afSample,]$dateICD10 <- as.character(afSampleDate[which.min(afSampleDate)])
}

sum(duplicated(idx%%nSamples))
idx = unique(idx%%nSamples)
AFpheno$icd10[idx] <- 1


# --------------------------------
# icd 9

icdCodesList$ICD9[grep(defAF$f.41271, icdCodesList$ICD9)]
idx = which(icdCodesList$ICD9 %in% defAF$f.41271)

#add dates
dates = icdCodesList$dateICD9[idx]
names(idx) = AFpheno$sample.id[idx%%nSamples]

for(afSample in unique(names(idx))) {
  idxAfSample = which(names(idx) == afSample )
  afSampleDate = as.Date(dates[idxAfSample])
  AFpheno[afSample,]$dateICD9 <- as.character(afSampleDate[which.min(afSampleDate)])
}


idx = unique(idx%%nSamples)
AFpheno$icd9[idx] <- 1


# --------------------------------
# opcs4

table(icdCodesList$OPCS4[icdCodesList$OPCS4 %in% defAF$f.41272])
idx = which(icdCodesList$OPCS4 %in% defAF$f.41272)

#add dates
dates = icdCodesList$dateOPCS4[idx]
names(idx) = AFpheno$sample.id[idx%%nSamples]

for(afSample in unique(names(idx))) {
  idxAfSample = which(names(idx) == afSample )
  afSampleDate = as.Date(dates[idxAfSample])
  AFpheno[afSample,]$dateOPCS4 <- as.character(afSampleDate[which.min(afSampleDate)])
}



idx = unique(idx%%nSamples)
AFpheno$opcs4[idx] <- 1

AFpheno[idx,]

# --------------------------------
# self reported

idx = which(icdCodesList$illnessSelfreported %in% defAF$f.20002)
#icdCodesList$illnessSelfreported[idx]
age = icdCodesList$ageIllnessSelfreported[idx]
names(idx) = AFpheno$sample.id[idx%%nSamples]

for(afSample in unique(names(idx))) {
  idxAfSample = which(names(idx) == afSample )
  afSampleAge = age[idxAfSample]
  AFpheno[afSample,]$illSRage <- afSampleAge[which.min(afSampleAge)]
}


idx = unique(idx%%nSamples)
AFpheno$illSR[idx] <- 1


# --------------------------------
# opertation self reported
idx = which(icdCodesList$opCodeSelfReported %in% defAF$f.20004)

age = icdCodesList$ageOpCodeSelfReported[idx]
names(idx) = AFpheno$sample.id[idx%%nSamples]

for(afSample in unique(names(idx))) {
  idxAfSample = which(names(idx) == afSample )
  afSampleAge = age[idxAfSample]
  AFpheno[afSample,]$opSRage <- afSampleAge[which.min(afSampleAge)]
}


idx = unique(idx%%nSamples)
AFpheno$opSR[idx] <- 1

AFpheno[idx,]


# ---------------------------------------------
#
# Print
# 

AFpheno$dateOfBirth <- pheno$dateOfBirth

write.table(AFpheno,
            file = "../../data/phenotypes/AF.tab",
            col.names = T,
            quote = F,
            row.names = F
)


# ---------------------------------------------
#
# Summary
# 

sum(rowSums(AFpheno[sample.eth.exo.id,c('icd10',"icd9","opcs4","illSR","opSR")]) > 0)
pheno$af = ifelse(rowSums(AFpheno[,c('icd10',"icd9","opcs4","illSR","opSR")]) > 0,1,0)

# based on icd
idxAFdate = which(rowSums(AFpheno[,c('icd10',"icd9","opcs4")]) > 0)

earliestDates = apply(AFpheno[idxAFdate,c("dateICD10","dateICD9", "dateOPCS4")],1, function(x){
  x = x[!x == 0]
  x[which.min(as.Date(x))]
})

ageOfOnset <- round(time_length( difftime(earliestDates, pheno$dateOfBirth[idxAFdate]), "years"), digits = 1)

pheno$ageOfOnset = ""
pheno[names(earliestDates),"ageOfOnset"] <- ageOfOnset

# based on self reported
idxAFdate = which(rowSums(AFpheno[,c('icd10',"icd9","opcs4")]) == 0 & rowSums(AFpheno[,c('illSR',"opSR")]) > 0 )

youngestAge = apply(AFpheno[idxAFdate,c("illSRage","opSRage")],1, function(x){
  x[x %in% c(-1,-3)] <- 150
  x = x[!x == 0]
  x[which.min(x)]
})

youngestAge[youngestAge == 150] <- NA
pheno[names(youngestAge),"ageOfOnset"] <- youngestAge

summary(as.numeric(pheno$ageOfOnset), na.rm = T)

#hist(as.numeric(pheno[sample.eth.exo.id,]$ageOfOnset))
#boxplot(as.numeric(pheno[sample.eth.exo.id,]$ageOfOnset))


#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################



