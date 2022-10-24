#
# define HF and cardiomyopathy phenotype
# 
# ---------------------------------------------
#
# df
#


defCM = list(f.20002 = c("1079","1588"),
             f.41270 = c("I255","I42","I420","I421","I422","I425","I428","I429"),
             f.41271 = c("425","4251","4254"),
             exclude = c(0,0,0)
)

defHF = list(f.20002 = c("1076"),
             f.41270 = c("I110","I130","I132","I50","I500","I501","I509"),
             f.41271 = c("428","4280", "4281", "4289"),
             exclude = c(0,0,0)
)

nSamples = dim(icdCodesList$ICD10)[1]


# ---------------------------------------------
#
# HF
# 


HFpheno = data.frame(sample.id = rownames(icdCodesList$ICD10),
                     icd10 = rep(0, nSamples),
                     dateICD10 = rep(0, nSamples),
                     icd9 = rep(0, nSamples),
                     dateICD9 = rep(0, nSamples),
                     illSR = rep(0, nSamples),
                     illSRage = rep(0, nSamples),
                     stringsAsFactors = F
)

rownames(HFpheno) <-HFpheno$sample.id

# --------------------------------
#icd 10

idx = which(icdCodesList$ICD10 %in% defHF$f.41270)
dates = icdCodesList$dateICD10[idx]

#add dates
names(idx) = HFpheno$sample.id[idx%%nSamples]

for(HFSample in unique(names(idx))) {
  idxHFSample = which(names(idx) == HFSample )
  HFSampleDate = as.Date(dates[idxHFSample])
  HFpheno[HFSample,]$dateICD10 <- as.character(HFSampleDate[which.min(HFSampleDate)])
}

sum(duplicated(idx%%nSamples))
idx = unique(idx%%nSamples)
HFpheno$icd10[idx] <- 1


# --------------------------------
# icd 9


idx = which(icdCodesList$ICD9 %in% defHF$f.41271)

#add dates
dates = icdCodesList$dateICD9[idx]
names(idx) = HFpheno$sample.id[idx%%nSamples]

for(HFSample in unique(names(idx))) {
  idxHFSample = which(names(idx) == HFSample )
  HFSampleDate = as.Date(dates[idxHFSample])
  HFpheno[HFSample,]$dateICD9 <- as.character(HFSampleDate[which.min(HFSampleDate)])
}

idx = unique(idx%%nSamples)
HFpheno$icd9[idx] <- 1


# --------------------------------
# self reported

idx = which(icdCodesList$illnessSelfreported %in% defHF$f.20002)
#icdCodesList$illnessSelfreported[idx]
age = icdCodesList$ageIllnessSelfreported[idx]
names(idx) = HFpheno$sample.id[idx%%nSamples]

for(HFSample in unique(names(idx))) {
  idxHFSample = which(names(idx) == HFSample )
  HFSampleAge = age[idxHFSample]
  HFpheno[HFSample,]$illSRage <- HFSampleAge[which.min(HFSampleAge)]
}


idx = unique(idx%%nSamples)
HFpheno$illSR[idx] <- 1


# ---------------------------------------------
#
# CM
# 

CMpheno = data.frame(sample.id = rownames(icdCodesList$ICD10),
                     icd10 = rep(0, nSamples),
                     dateICD10 = rep(0, nSamples),
                     icd9 = rep(0, nSamples),
                     dateICD9 = rep(0, nSamples),
                     illSR = rep(0, nSamples),
                     illSRage = rep(0, nSamples),
                     stringsAsFactors = F
)

rownames(CMpheno) <-CMpheno$sample.id

# --------------------------------
#icd 10

idx = which(icdCodesList$ICD10 %in% defCM$f.41270)
dates = icdCodesList$dateICD10[idx]

#add dates
names(idx) = CMpheno$sample.id[idx%%nSamples]

for(CMSample in unique(names(idx))) {
  idxCMSample = which(names(idx) == CMSample )
  CMSampleDate = as.Date(dates[idxCMSample])
  CMpheno[CMSample,]$dateICD10 <- as.character(CMSampleDate[which.min(CMSampleDate)])
}

sum(duplicated(idx%%nSamples))
idx = unique(idx%%nSamples)
CMpheno$icd10[idx] <- 1


# --------------------------------
# icd 9


idx = which(icdCodesList$ICD9 %in% defCM$f.41271)

#add dates
dates = icdCodesList$dateICD9[idx]
names(idx) = CMpheno$sample.id[idx%%nSamples]

for(CMSample in unique(names(idx))) {
  idxCMSample = which(names(idx) == CMSample )
  CMSampleDate = as.Date(dates[idxCMSample])
  CMpheno[CMSample,]$dateICD9 <- as.character(CMSampleDate[which.min(CMSampleDate)])
}

idx = unique(idx%%nSamples)
CMpheno$icd9[idx] <- 1


# --------------------------------
# self reported

idx = which(icdCodesList$illnessSelfreported %in% defCM$f.20002)
age = icdCodesList$ageIllnessSelfreported[idx]
names(idx) = CMpheno$sample.id[idx%%nSamples]

for(CMSample in unique(names(idx))) {
  idxCMSample = which(names(idx) == CMSample )
  CMSampleAge = age[idxCMSample]
  CMpheno[CMSample,]$illSRage <- CMSampleAge[which.min(CMSampleAge)]
}


idx = unique(idx%%nSamples)
CMpheno$illSR[idx] <- 1



# ---------------------------------------------
#
# Print
# 

HFpheno$dateOfBirth <- pheno$dateOfBirth
CMpheno$dateOfBirth <- pheno$dateOfBirth

write.table(HFpheno,
            file = "../../data/phenotypes/HF.tab",
            col.names = T,
            quote = F,
            row.names = F
)

write.table(CMpheno,
            file = "../../data/phenotypes/CM.tab",
            col.names = T,
            quote = F,
            row.names = F
)


# ---------------------------------------------
#
# Summary
# 

sum(rowSums(HFpheno[,c('icd10',"icd9","illSR")]) > 0)
sum(rowSums(CMpheno[,c('icd10',"icd9","illSR")]) > 0)

pheno$hf = ifelse(rowSums(HFpheno[,c('icd10',"icd9","illSR")]) > 0,1,0)
pheno$cm = ifelse(rowSums(CMpheno[,c('icd10',"icd9","illSR")]) > 0,1,0)

idxHFdate = which(rowSums(HFpheno[,c('icd10',"icd9")]) > 0)
idxCMdate = which(rowSums(CMpheno[,c('icd10',"icd9")]) > 0)

# hf icd dates
earliestDates = apply(HFpheno[idxHFdate,c("dateICD10","dateICD9")],1, function(x){
  x = x[!x == 0]
  x[which.min(as.Date(x))]
})

ageOfOnset <- round(time_length( difftime(earliestDates, pheno$dateOfBirth[idxHFdate]), "years"), digits = 1)
pheno$HFonset = ""
pheno[names(earliestDates),"HFonset"] <- ageOfOnset


# cm icd dates
earliestDates = apply(CMpheno[idxCMdate,c("dateICD10","dateICD9")],1, function(x){
  x = x[!x == 0]
  x[which.min(as.Date(x))]
})

ageOfOnset <- round(time_length( difftime(earliestDates, pheno$dateOfBirth[idxCMdate]), "years"), digits = 1)
pheno$CMonset = ""
pheno[names(earliestDates),"CMonset"] <- ageOfOnset


# HF dates based on self reported
idxHFdate = which(rowSums(HFpheno[,c('icd10',"icd9")]) == 0 & (HFpheno[,c('illSR')] > 0) )
pheno[idxHFdate, "HFonset"] <- HFpheno[idxHFdate,c("illSRage")]
pheno$HFonset[pheno[,"HFonset"] %in% c(-1,-3,-9999)] <- NA


# CM dates based on self reported
idxCMdate = which(rowSums(CMpheno[,c('icd10',"icd9")]) == 0 & (CMpheno[,c('illSR')] > 0) )
pheno[idxCMdate, "CMonset"] <- CMpheno[idxCMdate,c("illSRage")]
pheno$CMonset[pheno[,"CMonset"] %in% c(-1,-3,-9999)] <- NA



# cm&hf + age
pheno$hf_cm = ifelse(rowSums(pheno[,c('hf','cm')]) > 0, 1, 0)
idxHFCMdate = which(pheno$HFonset != "" | pheno$CMonset != "")

earliestAge = apply(pheno[idxHFCMdate,c("HFonset","CMonset")],1, function(x){
  x = x[!x == ""]
  x[which.min(x)]
})

pheno$hf_cmAge = ""
pheno[names(earliestAge),"hf_cmAge"] <- earliestAge


#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################

