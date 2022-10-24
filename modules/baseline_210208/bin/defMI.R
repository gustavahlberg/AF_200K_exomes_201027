# ---------------------------------------------
#
# MI
# 
# ---------------------------------------------
# 
# 42000	Date of myocardial infarction
# 42001	Source of myocardial infarction report
# 42002	Date of STEMI
# 42003	Source of STEMI report
# 42004	Date of NSTEMI
# 42005	Source of NSTEMI report
#
# --------------------------------------------


MIpheno = data.frame(sample.id = h5read(h5.fn,"sample.id"),
                     mi = h5read(h5.fn,"f.42001/f.42001"),
                     dateMI = h5read(h5.fn,"f.42000/f.42000"),
                     stemi = h5read(h5.fn,"f.42003/f.42003"),
                     dateStemi = h5read(h5.fn,"f.42002/f.42002"),
                     nstemi = h5read(h5.fn,"f.42005/f.42005"),
                     dateNstemi = h5read(h5.fn,"f.42004/f.42004")
                     )

rownames(MIpheno) <- MIpheno$sample.id
MIpheno <- MIpheno[pheno$sample.id,] 
MIpheno[MIpheno == -9999] <- NA

dateOfMI = as.Date(MIpheno$dateMI, format = "%Y-%m-%d")
dateOfMI[which(dateOfMI == as.Date('1900-01-01',format = "%Y-%m-%d"))] <- NA
MIpheno$ageAtMI <- round(time_length(difftime(dateOfMI, pheno$dateOfBirth), "years"), digits = 1)


dateStemi = as.Date(MIpheno$dateStemi, format = "%Y-%m-%d")
dateStemi[which(dateStemi == as.Date('1900-01-01',format = "%Y-%m-%d"))] <- NA
MIpheno$ageAtSTEMI <- round(time_length(difftime(dateStemi, pheno$dateOfBirth), "years"), digits = 1)


dateNstemi = as.Date(MIpheno$dateNstemi, format = "%Y-%m-%d")
dateNstemi[which(dateNstemi == as.Date('1900-01-01',format = "%Y-%m-%d"))] <- NA
MIpheno$ageAtNSTEMI <- round(time_length(difftime(dateNstemi, pheno$dateOfBirth), "years"), digits = 1)


# ---------------------------------------------
#
# Print
# 

MIpheno$dateOfBirth <- pheno$dateOfBirth

write.table(MIpheno,
            file = "../../data/phenotypes/MIpheno.tab",
            col.names = T,
            quote = F,
            row.names = F
)



# ---------------------------------------------
#
# Summary
# 


pheno$mi <- ifelse(is.na(MIpheno$mi), 0, 1)
pheno$ageAtMI <- MIpheno$ageAtMI
pheno$hardMI <- ifelse(MIpheno$mi %in% c(1,2), 1, 0)

pheno$stemi <- ifelse(is.na(MIpheno$stemi), 0, 1)
pheno$ageAtSTEMI <- MIpheno$ageAtSTEMI

pheno$nstemi <- ifelse(is.na(MIpheno$nstemi), 0, 1)
pheno$ageAtNSTEMI <- MIpheno$ageAtNSTEMI




#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################