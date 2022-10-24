#
#
# covarites
# 
# age, sex, weight, bmi, etc 
# bsa, PC1-10, batch, indexed measures
#
# ---------------------------------------------
#
# load data
#

h5ls(h5.fn)
cov = data.frame(sample.id = h5read(h5.fn,"sample.id"))
rownames(cov) = cov$sample.id

length(sample.eth.id)
length(sample.eth.exo.id)

# ---------------------------------------------
#
# age at inclusion
#

h5readAttributes(h5.fn,"f.21003")
cov$age = h5read(h5.fn,"f.21003/f.21003")[,1]

# ---------------------------------------------
#
# sex
#

sex = h5read(h5.fn,"f.31/f.31")[,1]
sexGen = h5read(h5.fn,"f.22001/f.22001")[,1]

sexMismatch = which(sex != sexGen)
sex[sexMismatch] <- NA

cov$sex <- sex


# ---------------------------------------------
#
# Imaging center
#



h5readAttributes(h5.fn,"f.54")
h5readAttributes(h5.fn,"f.54/f.54")[,3]
cov$imgCenter = h5read(h5.fn,"f.54/f.54")[,3]
cov$imgCenter[cov$imgCenter == -9999] <- NA

cov$AgeImgCenter <- h5read(h5.fn,"f.21003/f.21003")[,3]
cov$AgeImgCenter[cov$AgeImgCenter == -9999] <- NA

# ---------------------------------------------
#
# height & weight
# Body Surface Area (BSA) (Dubois and Dubois) = 
# 0.007184 x (patient height in cm)0.725 x (patient weight in kg)0.425
#
# height
h5readAttributes(h5.fn,"f.50/f.50")
cov$height = h5read(h5.fn,"f.50/f.50")[,1]
cov$height[cov$height == -9999] <- NA

# weight
cov$weight =  h5read(h5.fn,"f.21002/f.21002")[,1]
cov$weight[cov$weight == -9999] <- NA


# bsa & bmi
cov$bsa =  0.007184*(cov$height^0.725) * (cov$weight^0.425)
cov$bmi = cov$weight/(cov$height/100)^2


# ---------------------------------------------
#
# diastolic BP
#

h5readAttributes(h5.fn,"f.4079")
h5readAttributes(h5.fn,"f.4079/f.4079")
dbp = h5read(h5.fn,"f.4079/f.4079")
rownames(dbp) <- row.names(cov)

dbp.2 = ifelse(dbp[,c(1)] <=  dbp[,c(2)] & dbp[,c(1)] != -9999, 
               dbp[,c(1)],  ifelse( dbp[,c(2)] == -9999, dbp[,c(1)],  dbp[,c(2)] ))

dbp.3 = dbp[dbp.2 == -9999,]
dbp.4 = ifelse(dbp.3[,c(3)] <=  dbp.3[,c(4)] & dbp.3[,c(3)] != -9999, 
               dbp.3[,c(3)],  ifelse( dbp.3[,c(4)] == -9999, dbp.3[,c(3)],  dbp.3[,c(4)] ))

dbp.5 = dbp.3[dbp.4 == -9999,]

dbp.6 = ifelse(dbp.5[,c(5)] <=  dbp.5[,c(6)] & dbp.5[,c(5)] != -9999, 
               dbp.5[,c(5)],  ifelse( dbp.5[,c(6)] == -9999, dbp.5[,c(5)],  dbp.5[,c(6)] ))


#check
any(duplicated(c(names(dbp.2[dbp.2 != -9999]), names(dbp.4[dbp.4 != -9999]), names(dbp.6))))
length(c(names(dbp.2[dbp.2 != -9999]), names(dbp.4[dbp.4 != -9999]), names(dbp.6)))

dbp.2[names(dbp.4)] <- dbp.4
dbp.2[names(dbp.6)] <- dbp.6
dbp.2[dbp.2 == -9999] <- NA


cov$dbp <- dbp.2
hist(cov$dbp); summary(cov$dbp)

# ---------------------------------------------
#
# systolic BP
#

h5readAttributes(h5.fn,"f.4080")
h5readAttributes(h5.fn,"f.4080/f.4080")
sbp = h5read(h5.fn,"f.4080/f.4080")
rownames(sbp) <- row.names(cov)

sbp.2 = ifelse(sbp[,c(1)] <=  sbp[,c(2)] & sbp[,c(1)] != -9999, 
               sbp[,c(1)],  ifelse( sbp[,c(2)] == -9999, sbp[,c(1)],  sbp[,c(2)] ))

sbp.3 = sbp[sbp.2 == -9999,]
sbp.4 = ifelse(sbp.3[,c(3)] <=  sbp.3[,c(4)] & sbp.3[,c(3)] != -9999, 
               sbp.3[,c(3)],  ifelse( sbp.3[,c(4)] == -9999, sbp.3[,c(3)],  sbp.3[,c(4)] ))

sbp.5 = sbp.3[sbp.4 == -9999,]

sbp.6 = ifelse(sbp.5[,c(5)] <=  sbp.5[,c(6)] & sbp.5[,c(5)] != -9999, 
               sbp.5[,c(5)],  ifelse( sbp.5[,c(6)] == -9999, sbp.5[,c(5)],  sbp.5[,c(6)] ))


#check
any(duplicated(c(names(sbp.2[sbp.2 != -9999]), names(sbp.4[sbp.4 != -9999]), names(sbp.6))))
length(c(names(sbp.2[sbp.2 != -9999]), names(sbp.4[sbp.4 != -9999]), names(sbp.6)))

sbp.2[names(sbp.4)] <- sbp.4
sbp.2[names(sbp.6)] <- sbp.6
sbp.2[sbp.2 == -9999] <- NA

cov$sbp <- sbp.2
hist(cov$sbp); summary(cov$sbp)

# ---------------------------------------------
#
# PC1-10 & batch
#

h5readAttributes(h5.fn,"f.22009")
h5readAttributes(h5.fn,"f.22009/f.22009")
PCs = h5read(h5.fn,"f.22009/f.22009")[,1:10]
colnames(PCs) <- paste0("PC",1:10)
cov <- cbind(cov, PCs)

h5readAttributes(h5.fn,"f.22000")
garray = h5read(h5.fn,"f.22000/f.22000")
garray[garray == -9999] <- NA
cov$genotyping.array <- ifelse(garray < 0, 'UKBL', 'UKBB')
#cov$genotyping.array[is.na(garray)] <- NA

table(cov$genotyping.array)


# ---------------------------------------------
#
# exome batch
#



# ---------------------------------------------
#
# save covarites table
#

cov <- cov[sample.eth.id,]

date = format(Sys.time(), "%y%m%d")
write.table(cov,
            file = paste0("../../data/phenotypes/covarites_",date,".tab"),
            col.names = T,
            quote = F,
            row.names = F
)




# ---------------------------------------------
#
# Cognitive function
#

h5readAttributes(h5.fn,"f.4282")
h5readAttributes(h5.fn,"f.4282/f.4282")
numeric = h5read(h5.fn,"f.4282/f.4282")
rownames(numeric) = sample.id[,1]
numeric[numeric == -9999] <- NA
numeric[numeric == -1] <- NA
numeric[numeric == 'NaN'] <- NA
numeric = rowMeans(numeric,na.rm = T)
numeric[numeric == 'NaN'] <- NA

h5readAttributes(h5.fn,"f.20023")
reactionTime = h5read(h5.fn,"f.20023/f.20023")
rownames(reactionTime) = sample.id[,1]
reactionTime[reactionTime == -9999] <- NA
reactionTime = rowMeans(reactionTime,na.rm = T)
reactionTime[reactionTime == 'NaN'] <- NA


h5readAttributes(h5.fn,"f.20016")
h5readAttributes(h5.fn,"f.20016/f.20016")
fluidInt = h5read(h5.fn,"f.20016/f.20016")
rownames(fluidInt) = sample.id[,1]
fluidInt[fluidInt == -9999] <- NA
fluidInt = rowMeans(fluidInt,na.rm = T)
fluidInt[fluidInt == 'NaN'] <- NA


h5readAttributes(h5.fn,"f.399")
h5readAttributes(h5.fn,"f.399/f.399")
pairsMatching = h5read(h5.fn,"f.399/f.399")

pairsMatching[pairsMatching == -9999] <- NA
pairsMatching = rowMeans(pairsMatching[,c(2,5,8,11)],na.rm = T)
hist(pairsMatching)
pairsMatching[pairsMatching == 'NaN'] <- NA


h5readAttributes(h5.fn,"f.20018")
h5readAttributes(h5.fn,"f.20018/f.20018")
prospectiveMemory = h5read(h5.fn,"f.20018/f.20018")
rownames(prospectiveMemory) = sample.id[,1]
prospectiveMemory[prospectiveMemory == -9999] <- NA
prospectiveMemory = apply(prospectiveMemory,1 , function(x){
  if(all(is.na(x))) {
    return(NA)
  } else{
    idx  = which(!is.na(x))
    return(x[idx[which.max(idx)]])
  }
})



h5readAttributes(h5.fn,"f.6348")
h5readAttributes(h5.fn,"f.6348/f.6348")
trailMakingNum = h5read(h5.fn,"f.6348/f.6348")
rownames(trailMakingNum) = sample.id[,1]
trailMakingNum = trailMakingNum[samplesCMR,]
trailMakingNum[trailMakingNum == -9999] <- NA
trailMakingNum = rowMeans(trailMakingNum, na.rm = T)
trailMakingNum[trailMakingNum == 'NaN'] <- NA
trailMakingNum[trailMakingNum == 0] <- NA

h5readAttributes(h5.fn,"f.6350")
trailMakingAlphaNum = h5read(h5.fn,"f.6350/f.6350")
rownames(trailMakingAlphaNum) = sample.id[,1]
trailMakingAlphaNum[trailMakingAlphaNum == -9999] <- NA
trailMakingAlphaNum = rowMeans(trailMakingAlphaNum, na.rm = T)
trailMakingAlphaNum[trailMakingAlphaNum == 'NaN'] <- NA
trailMakingAlphaNum[trailMakingAlphaNum == 0] <- NA


cogDf = data.frame(
  trailMakingAlphaNum,
  trailMakingNum,
  pairsMatching,
  fluidInt,
  reactionTime,
  numeric)

summary(cogDf)
rownames(cogDf) <- sample.id[,1]
cogDf$sample.id <- sample.id[,1]

cogDf <- cogDf[sample.eth.id,]

# save cogDf
write.table(cogDf,
            file = "../../data/phenotypes/cognitiveMeasures.tab",
            sep = "\t",
            col.names = T,
            row.names = F,
            quote = F)



########################
cor(ifelse(apply(cogDf,2,is.na), 2,1))
# all cog var
dim(cogDf[which(rowSums(is.na(cogDf)) <= 0),])
cogAllDf <- cogDf[which(rowSums(is.na(cogDf)) <= 0),]
cor(cogAllDf)
s = svd(t(cogAllDf))
round(sqrt(2) * s$u , 3)
str(s)
PC1 = s$d[1]*s$v[,1]
PC2 = s$d[2]*s$v[,2]
plot(PC1,PC2)
plot(s$d^2/sum(s$d^2)*100,ylab="Percent variability explained")




#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################
