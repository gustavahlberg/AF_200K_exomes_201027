#
# define AF
# 
# ---------------------------------------------
#
# df
# 

names(icdCodesList_test)

defAF = list(f.20002 = c(1471, 1483),
             f.20004 = c(1524),
             f.40001 = c("I48"),
             f.40002 = c("I48"),
             f.41202 = c("I48"),
             f.41204 = c("I48"),
             f.41203 = c("4273"),
             f.41205 = c("4273"),
             f.41200 = c("K571", "K621", "K622", "K623", "K624","X501","X502"),
             f.41210 = c("K571", "K621", "K622", "K623", "K624","X501","X502")
)


nSamples = dim(icdCodesList_test$ICD10_main)[1]


# ---------------------------------------------
#
# AF
# 


AFpheno2 = data.frame(sample.id = rownames(icdCodesList_test$ICD10_main),
                     ICD10_main = rep(0, nSamples),
                     ICD10_sec = rep(0, nSamples),               
                     ICD9_main = rep(0, nSamples),
                     ICD9_sec = rep(0, nSamples),
                     OPCS4_main = rep(0, nSamples),              
                     OPCS4_sec = rep(0, nSamples),
                     causeDeathICD10_primary = rep(0, nSamples), 
                     causeDeathICD10_second = rep(0, nSamples),
                     illnessSelfreported = rep(0, nSamples),
                     opCodeSelfReported = rep(0, nSamples),
                     stringsAsFactors = F
                     )


# --------------------------------
# death registry

table(icdCodesList_test$causeDeathICD10_primary[grep(defAF$f.40001, icdCodesList_test$causeDeathICD10_primary )])
idx = grep(defAF$f.40001, icdCodesList_test$causeDeathICD10_primary)
idx = unique(idx%%nSamples)
AFpheno2$causeDeathICD10_primary[idx] <- 1

table(icdCodesList_test$causeDeathICD10_second[grep(defAF$f.40002, icdCodesList_test$causeDeathICD10_second )])
idx = grep(defAF$f.40002, icdCodesList_test$causeDeathICD10_second)
idx = unique(idx%%nSamples)
AFpheno2$causeDeathICD10_primary[idx] <- 1


# --------------------------------
#icd 10

table(icdCodesList_test$ICD10_main[grep(defAF$f.41202, icdCodesList_test$ICD10_main )])
idx = grep(defAF$f.41202, icdCodesList_test$ICD10_main)
idx = unique(idx%%nSamples)
AFpheno2$ICD10_main[idx] <- 1


table(icdCodesList_test$ICD10_sec[grep(defAF$f.41204, icdCodesList_test$ICD10_sec )])
idx = grep(defAF$f.41204, icdCodesList_test$ICD10_sec)
idx = unique(idx%%nSamples)
AFpheno2$ICD10_sec[idx] <- 1
AFpheno2$ICD10tmp[idx] <- 1

# --------------------------------
# icd 9

table(icdCodesList_test$ICD9_main[grep(defAF$f.41203, icdCodesList_test$ICD9_main )])
idx = grep(defAF$f.41202, icdCodesList_test$ICD9_main)
idx = unique(idx%%nSamples)
AFpheno2$ICD9_main[idx] <- 1

table(icdCodesList_test$ICD9_sec[grep(defAF$f.41205, icdCodesList_test$ICD9_sec )])
idx = grep(defAF$f.41205, icdCodesList_test$ICD9_sec)
idx = unique(idx%%nSamples)
AFpheno2$ICD9_sec[idx] <- 1



# --------------------------------
# opcs4

table(icdCodesList_test$OPCS4_main[icdCodesList_test$OPCS4_main %in% defAF$f.41200])
idx = which(icdCodesList_test$OPCS4_main %in% defAF$f.41200)
idx = unique(idx%%nSamples)
AFpheno2$OPCS4_main[idx] <- 1

table(icdCodesList_test$OPCS4_sec[icdCodesList_test$OPCS4_sec %in% defAF$f.41210])
idx = which(icdCodesList_test$OPCS4_sec %in% defAF$f.41210)
idx = unique(idx%%nSamples)
AFpheno2$OPCS4_sec[idx] <- 1




# --------------------------------
# self reported

idx = which(icdCodesList_test$illnessSelfreported %in% defAF$f.20002)
idx = unique(idx%%nSamples)
AFpheno2$illnessSelfreported[idx] <- 1

idx = which(icdCodesList_test$opCodeSelfReported %in% defAF$f.20004)
idx = unique(idx%%nSamples)
AFpheno2$opCodeSelfReported[idx] <- 1


# ---------------------------------------------
#
# Summary
# 

head(AFpheno)
head(AFpheno2)
rownames(AFpheno2) <- as.character(AFpheno2$sample.id)

AFphenoSub <-  AFpheno[,c('sample.id','icd10',"icd9","opcs4","illSR","opSR")]

AFpheno2$ICD10 <- ifelse(AFpheno2$ICD10_main > 0 | AFpheno2$ICD10_sec > 0, 1, 0)
AFpheno2$ICD9 <- ifelse(AFpheno2$ICD9_main > 0 | AFpheno2$ICD9_sec > 0, 1, 0)
AFpheno2$OPCS4 <- ifelse(AFpheno2$OPCS4_main > 0 | AFpheno2$OPCS4_sec > 0, 1, 0)

# ---------------------------------------------
#
# Check diffs.
# 

colSums(AFphenoSub[sample.eth.exo.id,-1])
colSums(AFpheno2[sample.eth.exo.id,-1])

sum(rowSums(AFphenoSub[sample.eth.exo.id,-1]) >= 1)
sum(rowSums(AFpheno2[sample.eth.exo.id,-1]) >= 1)

afVec1 <- ifelse(rowSums(AFphenoSub[sample.eth.exo.id,-1]) >= 1, 1,0)
afVec2 <- ifelse(rowSums(AFpheno2[sample.eth.exo.id,-1]) >= 1, 1,0)
sum(afVec1);sum(afVec2)
sum(!afVec1 == afVec2)

table(afVec2[!(afVec2 == afVec1)])
AFpheno2[names(afVec2[(!(afVec2 == afVec1))]),]


h5readAttributes(h5.fn,"f.131351")
h5readAttributes(h5.fn,"f.131351/f.131351")$f.131351

f131351 <- h5read(h5.fn,"f.131351/f.131351")
f131351[f131351 == -9999,] <- 0
i48 <- f131351
i48[i48 != 0,] <- 1
rownames(i48) <- sample.id
rownames(f131351) <- sample.id

sum(i48[sample.eth.exo.id,])

table(f131351[sample.eth.exo.id,])
colSums(AFphenoSub[sample.eth.exo.id,-1])
colSums(AFpheno2[sample.eth.exo.id,-1])


idxNoM <- which(i48[sample.eth.exo.id,] != afVec1)
table(i48[sample.eth.exo.id,][idxNoM])

table(afVec1[idxNoM]); table(afVec2[idxNoM])

table(f131351[sample.eth.exo.id,][idxNoM])

sample.id.mismatch <- names(which(f131351[sample.eth.exo.id,][idxNoM] == 40))

head(icdCodesList$ICD10[sample.id.mismatch[3,],])
icdCodesList_test$ICD10_sec[sample.id.mismatch[3],]
icdCodesList$ICD9[sample.id.mismatch[3],]

f131351[sample.id.mismatch[3],]

