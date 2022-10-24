#
#
# subset to uk etnicity
#
#
# -----------------


sample.eth.id <- as.character(read.table("results/samplesUKBB.etn.201030.list")$V1)

ph_cols <- data.frame(
  sample.id=h5read(h5.fn,"sample.id"),
  country=h5read(h5.fn,"f.1647/f.1647")[,1], # country of birth in UK
  country2=h5read(h5.fn,"f.20115/f.20115")[,1], # country of birth outside UK
  ethnic=h5read(h5.fn,"f.21000/f.21000")[,1], # self-report ethnicity
  stringsAsFactors = F
) 


# ---------------------------------------------
#
# filter
#
# Used.in.pca.calculation filter 

qc_pass <- (sqc2$het.missing.outliers==0 &
              sqc2$excluded.from.kinship.inference==0 &
              sqc2$excess.relatives==0 #&
            #sqc2$used.in.pca.calculation==1
)

qc2 <- sqc2[qc_pass,]
ph2 = subset(ph_cols, sample.id %in% qc2$eid)
df <- merge(ph2, qc2, by.y="eid", by.x="sample.id")
df$exome <- 0
df$exome[df$sample.id %in% sample2CKExomes] <- 1


# get self-report whites
df$white <- (df$ethnic %in% c(1,1001,1002,1003))
df$ethnic_miss <- (df$ethnic %in% c(-3,-1,-9999))

df$genCac = rep(0, nrow(df))
samplesGenCac = qcTab$sample.id[qcTab$genCacuasian == 1]
sum(df$sample.id %in% samplesGenCac)
df$genCac[df$sample.id %in% samplesGenCac] <- 1

sum(df$white == T | df$ethnic_miss == T)
dfW <- df[df$white == T | df$ethnic_miss == T,]
dfOth <- df[!df$sample.id %in% dfW$sample.id,]
