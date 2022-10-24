#
#
# icd codes
# Extract fields
# 40001, 40002, 41200, 41202, 41203, 41204, 41205, 41210
#
# ---------------------------------------
#
# sample ids
#

#h5ls(h5.fn)

sample.id = h5read(h5.fn,"sample.id")
colnames(sample.id) = "sample.id"


# ----------------------------------------
#
# test ICD etc..
#
# Underlying (primary) cause of death: ICD10
h5readAttributes(h5.fn,"f.40001")
causeDeathICD10_primary = h5read(h5.fn,"f.40001/f.40001")
colnames(causeDeathICD10_primary) = h5readAttributes(h5.fn,"f.40001/f.40001")$f.40001
rownames(causeDeathICD10_primary) <- sample.id[,1]
causeDeathICD10_primary = causeDeathICD10_primary[sample.eth.id,]


# Contributory (secondary) causes of death: ICD10
h5readAttributes(h5.fn,"f.40002")
causeDeathICD10_second = h5read(h5.fn,"f.40002/f.40002")
colnames(causeDeathICD10_second) = h5readAttributes(h5.fn,"f.40002/f.40002")$f.40002
rownames(causeDeathICD10_second) <- sample.id[,1]
causeDeathICD10_second = causeDeathICD10_second[sample.eth.id,]


# Operative procedures - main OPCS4"
h5readAttributes(h5.fn,"f.41200")
OPCS4_main = h5read(h5.fn,"f.41200/f.41200")
colnames(OPCS4_main) = h5readAttributes(h5.fn,"f.41200/f.41200")$f.41200
rownames(OPCS4_main) <- sample.id[,1]
OPCS4_main = OPCS4_main[sample.eth.id,]


# Operative procedures - secondary OPCS4
h5readAttributes(h5.fn,"f.41210")
OPCS4_sec = h5read(h5.fn,"f.41210/f.41210")
colnames(OPCS4_sec) = h5readAttributes(h5.fn,"f.41210/f.41210")$f.41210
rownames(OPCS4_sec) <- sample.id[,1]
OPCS4_sec = OPCS4_sec[sample.eth.id,]


# Diagnoses - main ICD10
h5readAttributes(h5.fn,"f.41202")
ICD10_main = h5read(h5.fn,"f.41202/f.41202")
colnames(ICD10_main) = h5readAttributes(h5.fn,"f.41202/f.41202")$f.41202
rownames(ICD10_main) <- sample.id[,1]
ICD10_main = ICD10_main[sample.eth.id,]

# Diagnoses - main ICD9
h5readAttributes(h5.fn,"f.41203")
ICD9_main = h5read(h5.fn,"f.41203/f.41203")
colnames(ICD9_main) = h5readAttributes(h5.fn,"f.41203/f.41203")$f.41203
rownames(ICD9_main) <- sample.id[,1]
ICD9_main = ICD9_main[sample.eth.id,]

# Diagnoses - secondary ICD10"
h5readAttributes(h5.fn,"f.41204")
ICD10_sec = h5read(h5.fn,"f.41204/f.41204")
colnames(ICD10_sec) = h5readAttributes(h5.fn,"f.41204/f.41204")$f.41204
rownames(ICD10_sec) <- sample.id[,1]
ICD10_sec = ICD10_sec[sample.eth.id,]


#  Diagnoses - secondary ICD9
h5readAttributes(h5.fn,"f.41205")
ICD9_sec = h5read(h5.fn,"f.41205/f.41205")
colnames(ICD9_sec) = h5readAttributes(h5.fn,"f.41205/f.41205")$f.41205
rownames(ICD9_sec) <- sample.id[,1]
ICD9_sec = ICD9_sec[sample.eth.id,]

# 20004	Operation code, self reported
h5readAttributes(h5.fn,"f.20004")
opCodeSelfReported = h5read(h5.fn,"f.20004/f.20004")
colnames(opCodeSelfReported) = h5readAttributes(h5.fn,"f.20004/f.20004")$f.20004
rownames(opCodeSelfReported) <- sample.id[,1]
opCodeSelfReported = opCodeSelfReported[sample.eth.id,]

# 20002	Non-cancer illness code, self-reported
h5readAttributes(h5.fn,"f.20002")
illnessSelfreported = h5read(h5.fn,"f.20002/f.20002")
colnames(illnessSelfreported) = h5readAttributes(h5.fn,"f.20002/f.20002")$f.20002
rownames(illnessSelfreported) <- sample.id[,1]
illnessSelfreported = illnessSelfreported[sample.eth.id,]


icdCodesList_test = list(ICD10_main = ICD10_main,
                    ICD10_sec = ICD10_sec,
                    ICD9_main = ICD9_main,
                    ICD9_sec = ICD9_sec,
                    OPCS4_main = OPCS4_main,
                    OPCS4_sec = OPCS4_sec,
                    causeDeathICD10_primary = causeDeathICD10_primary,
                    causeDeathICD10_second = causeDeathICD10_second,
                    illnessSelfreported = illnessSelfreported,
                    opCodeSelfReported = opCodeSelfReported
)



str(icdCodesList_test)
rm(ICD10_main, ICD10_sec,ICD9_main,ICD9_sec,OPCS4_main,
   OPCS4_sec, causeDeathICD10_primary,
   causeDeathICD10_second, illnessSelfreported,
   opCodeSelfReported
)


