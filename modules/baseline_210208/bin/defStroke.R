# ---------------------------------------------
#
# Stroke
# 
# ---------------------------------------------


StrokePheno <- data.frame(sample.id = rownames(icdCodesList$ICD10),
                          stroke = 0,
                          ageOfStroke = NA,
                          ischStroke = 0 ,
                          ageAtIschStroke = NA,
                          intracerebralHaemorrhage = 0 ,
                          ageIntracerebralHaemorrhage = NA,
                          subarachnoidHaemorrhage = 0,
                          ageSubarachnoidHaemorrhage = NA 
)

# ---------------------------------------------
#
# stroke
#

h5readAttributes(h5.fn,"f.42007")
stroke = as.vector(h5read(h5.fn,"f.42007/f.42007"))
names(stroke) = h5read(h5.fn,"sample.id")
stroke[stroke == -9999] <- NA
StrokePheno$stroke = stroke[StrokePheno$sample.id]


h5readAttributes(h5.fn,"f.42006")
dateOfstroke = as.Date(h5read(h5.fn,"f.42006/f.42006"), format = "%Y-%m-%d")
dateOfstroke[which(dateOfstroke == as.Date('1900-01-01',format = "%Y-%m-%d"))] <- NA
names(dateOfstroke) <- h5read(h5.fn,"sample.id")
dateOfstroke <- dateOfstroke[StrokePheno$sample.id]
all(pheno$sample.id == names(dateOfstroke))
StrokePheno$ageOfStroke = round(time_length(difftime(dateOfstroke, pheno$dateOfBirth), "years"), digits = 1)


# ---------------------------------------------
#
# ischemic stroke
#

h5readAttributes(h5.fn,"f.42009")
ischStroke = as.vector(h5read(h5.fn,"f.42009/f.42009"))
names(ischStroke) = h5read(h5.fn,"sample.id")
ischStroke[ischStroke == -9999] <- NA
StrokePheno$ischStroke = ischStroke[StrokePheno$sample.id]


h5readAttributes(h5.fn,"f.42008")
dateOfstroke = as.Date(h5read(h5.fn,"f.42008/f.42008"), format = "%Y-%m-%d")
dateOfstroke[which(dateOfstroke == as.Date('1900-01-01',format = "%Y-%m-%d"))] <- NA
names(dateOfstroke) <- h5read(h5.fn,"sample.id")
dateOfstroke <- dateOfstroke[StrokePheno$sample.id]
all(pheno$sample.id == names(dateOfstroke))
StrokePheno$ageAtIschStroke = round(time_length(difftime(dateOfstroke, pheno$dateOfBirth), "years"), digits = 1)


# ---------------------------------------------
#
# intracerebral Haemorrhage
#

h5readAttributes(h5.fn,"f.42011")
intracerebralHaemorrhage = as.vector(h5read(h5.fn,"f.42011/f.42011"))
names(intracerebralHaemorrhage) = h5read(h5.fn,"sample.id")
intracerebralHaemorrhage[intracerebralHaemorrhage == -9999] <- NA
StrokePheno$intracerebralHaemorrhage = intracerebralHaemorrhage[StrokePheno$sample.id]


h5readAttributes(h5.fn,"f.42010")
dateOfstroke = as.Date(h5read(h5.fn,"f.42010/f.42010"), format = "%Y-%m-%d")
dateOfstroke[which(dateOfstroke == as.Date('1900-01-01',format = "%Y-%m-%d"))] <- NA
names(dateOfstroke) <- h5read(h5.fn,"sample.id")
dateOfstroke <- dateOfstroke[StrokePheno$sample.id]
all(pheno$sample.id == names(dateOfstroke))
StrokePheno$ageIntracerebralHaemorrhage = round(time_length(difftime(dateOfstroke, pheno$dateOfBirth), "years"), 
                                                digits = 1)


# ---------------------------------------------
#
# subarachnoid Haemorrhage
#

h5readAttributes(h5.fn,"f.42013")
subarachnoidHaemorrhage = as.vector(h5read(h5.fn,"f.42013/f.42013"))
names(subarachnoidHaemorrhage) = h5read(h5.fn,"sample.id")
subarachnoidHaemorrhage[subarachnoidHaemorrhage == -9999] <- NA
StrokePheno$subarachnoidHaemorrhage = subarachnoidHaemorrhage[StrokePheno$sample.id]


h5readAttributes(h5.fn,"f.42012")
dateOfstroke = as.Date(h5read(h5.fn,"f.42012/f.42012"), format = "%Y-%m-%d")
dateOfstroke[which(dateOfstroke == as.Date('1900-01-01',format = "%Y-%m-%d"))] <- NA
names(dateOfstroke) <- h5read(h5.fn,"sample.id")
dateOfstroke <- dateOfstroke[StrokePheno$sample.id]
all(pheno$sample.id == names(dateOfstroke))
StrokePheno$ageSubarachnoidHaemorrhage = round(time_length(difftime(dateOfstroke, pheno$dateOfBirth), "years"), 
                                    digits = 1)


# ---------------------------------------------
#
# Print
# 

StrokePheno$dateOfBirth <- pheno$dateOfBirth

write.table(StrokePheno,
            file = "../../data/phenotypes/StrokePheno.tab",
            col.names = T,
            quote = F,
            row.names = F
)


# ---------------------------------------------
#
# Summary
# 

pheno$stroke <- ifelse(is.na(StrokePheno$stroke), 0, 1)
pheno$ageOfStroke <- StrokePheno$ageOfStroke
pheno$hardstroke <- ifelse(StrokePheno$stroke %in% c(1,2), 1, 0)

pheno$ischStroke <- ifelse(is.na(StrokePheno$ischStroke), 0, 1)
pheno$ageAtIschStroke <- StrokePheno$ageAtIschStroke
pheno$hardischStroke <- ifelse(StrokePheno$ischStroke %in% c(1,2), 1, 0)

pheno$intracerebralHaemorrhage <- ifelse(is.na(StrokePheno$intracerebralHaemorrhage), 0, 1)
pheno$ageIntracerebralHaemorrhage <- StrokePheno$ageIntracerebralHaemorrhage
pheno$hardintracerebralHaemorrhage <- ifelse(StrokePheno$intracerebralHaemorrhage %in% c(1,2), 1, 0)

pheno$subarachnoidHaemorrhage <- ifelse(is.na(StrokePheno$subarachnoidHaemorrhage), 0, 1)
pheno$ageSubarachnoidHaemorrhage <- StrokePheno$ageSubarachnoidHaemorrhage
pheno$hardsubarachnoidHaemorrhage <- ifelse(StrokePheno$subarachnoidHaemorrhage %in% c(1,2), 1, 0)



#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################